; AUTHOR: Dimitri Vinci
; BRIEF DESCRIPTION:
; Domain for ex5 of APTP exam project
; PLANNING VERSION: Temporal planning, PDDL 2.1
; REQUIRE: strips + typing + equality + durative actions

(define 
    
    ; DOMAIN AND REQUIREMENTS DEFINITION SECTION
    
    (domain ex3_strip_plus)
    
    (:requirements :strips :typing :equality
    :durative-actions) ;; for handling time literals
    
    (:types 
        person box robot content - object  
        ; to handle not returning to depot
        generic_location - object
        location - generic_location
        depot - generic_location
        medicine tool food - content ;; subclassed content
        carrier - object ;; carrier of robot 
    )

    ; PREDICATES AND FUNCTION DEFINITION SECTION

    (:predicates
        ; position
        (be_at_person ?l - generic_location ?p - person)  ;; true if person is in a given location
        (be_at_box ?b - box ?l - generic_location)  ;; true if box is in a given location
        (be_at_content ?c - content ?l - generic_location)  ;; true if content is in a given location
        (be_at_robot ?l - generic_location ?r - robot )  ;; true if content is in a given location
        ; handle relation between object
        ; box
        (empty_box ?b - box)  ;; true if box not partecipate in any assigned_box_content predicate 
        (assigned_box_content ?b - box ?c - content)  ;; true if a box contain a content
        (not_assigned_box_content ?b - box ?c - content)  ;; negated version of previous predicate 
        (is_assigned_box ?b - box)  ;; check if a box is assigned to other robot (handle multi agent settings)
        (not_is_assigned_box ?b - box)  ;; negated version of previous predicate
        ; person
        (assigned_person_content ?c - content ?p - person)  ;; true if a person has assigned a content
        (not_assigned_person_content ?c - content ?p - person)  ;; negated version of previous predicate 
        ; to handle person satisfaction without or goal clause
        (satisfied_food ?p - person)
        (not_satisfied_food ?p - person)
        (satisfied_tool ?p - person)
        (not_satisfied_tool ?p - person)
        (satisfied_medicine ?p - person)
        (not_satisfied_medicine ?p - person)
        ; robot
        (assigned_robot_carrier ?c - carrier ?r - robot)  ;; true if robot is carrying an object
        (not_assigned_robot_carrier ?c - carrier ?r - robot )  ;; negated version of previous predicate
        ; content
        (is_assigned ?c - content)  ;; true if a content partecipate in at least one assigned assigned_box_content predicate
        (not_is_assigned ?c - content)  ;; negated versione of previous predicate 
        ; carrier
        (assigned_carrier_box ?b - box ?c - carrier )
        (not_assigned_carrier_box  ?b - box ?c - carrier)
        ; to handle carrier capacity
        (carrier_capacity_0 ?c - carrier)
        (carrier_capacity_1 ?c - carrier)
        (carrier_capacity_2 ?c - carrier)
        (carrier_capacity_3 ?c - carrier)
        (carrier_capacity_4 ?c - carrier)
        ; to force nonconcurrency in agent
        (agent_occupied ?r - robot)  ;; true if agent is occupied
        (not_agent_occupied ?r - robot)  ;; true if agent not occupied      
    )
    
    ; ACTION SECTION
    
    ; ACTION SECTION - handling boxes 
    
    (:durative-action fill_box
	:parameters (?b - box ?c - content ?l - generic_location ?r - robot )
	:duration(= ?duration 1)
        :condition (and
            ; robot, box and content in same location
            (over all (be_at_robot ?l ?r ))
            (over all (be_at_box ?b ?l))
            (over all (be_at_content ?c ?l))
            ; box must be empty 
            (at start (empty_box ?b))
            ; robot cannot steal content from box to other box 
            (at start (not_is_assigned ?c))
            ; force nonconcurrency
            (at start (not_agent_occupied ?r))
            ; robot cannot act on content handled by other bot
            (over all (not_is_assigned_box ?b)) 
        )
        :effect (and
            ; after fill the box, the box no more empty 
            (at start 
            	(not
                    (empty_box ?b)
                )
            )
            ; the content is then assigned  (ant set its negated corresponding predicate)
            (at start (is_assigned ?c))
            (at start 
            	(not
                    (not_is_assigned ?c)
                )
            )
            ; box is now assigned 
            (at end (assigned_box_content ?b ?c))
            (at end 
                (not
                    (not_assigned_box_content ?b ?c)
                )
            )
            ; force nonconcurrency
            (at start  (agent_occupied ?r))
            (at end (not (agent_occupied ?r)))
            (at start  (not (not_agent_occupied ?r)))
            (at end (not_agent_occupied ?r))
        )     
    )     
    
    ; ACTION SECTION - handling boxes - pick up
    
    ; pick up when carrier capacity is 4
    (:durative-action pick_up_cc_4
        :parameters (?b - box   ?cr - carrier ?l - generic_location ?r - robot)
        :duration(= ?duration 1)
        :condition (and
            ; robot, box and content in same location
            (over all (be_at_robot ?l ?r))
            (over all (be_at_box ?b ?l))
            ; carrier not have this box assigned 
            (at start (not_assigned_carrier_box ?b ?cr))
            (over all (assigned_robot_carrier ?cr ?r))  ;; carrier have to be assigned this robot 
            (at start (carrier_capacity_4 ?cr))  ;; current capacity is 4 
            ; force nonconcurrency
            (at start (not_agent_occupied ?r))
            (at start (not_is_assigned_box ?b))
        )
        :effect (and
            ; now carrier has this box assigned 
            (at start (assigned_carrier_box ?b ?cr))
            (at start 
                (not
                    (not_assigned_carrier_box ?b ?cr)
                )
            )
            ; decrease capacity
            (at end (carrier_capacity_3 ?cr))
            (at start 
                (not
                    (carrier_capacity_4 ?cr)
            	)
            )
            ; force nonconcurrency
            (at start  (agent_occupied ?r))
            (at end 
            	(not 
            	    (agent_occupied ?r)
            	)
            )
            (at start  
            	(not 
            	     (not_agent_occupied ?r)
            	)
            )
            (at end (not_agent_occupied ?r))
            ; box is now assigned
            (at start 
            	(not 
            	    (not_is_assigned_box ?b)
            	)
            )
            (at end (is_assigned_box ?b))
        )     
    )
    ; pick up when carrier capacity is 3
    (:durative-action pick_up_cc_3
        :parameters (?b - box  ?cr - carrier ?l - generic_location ?r - robot)
        :duration(= ?duration 1)
        :condition (and
            ; robot, box and content in same location
            (over all (be_at_robot ?l ?r))
            (over all (be_at_box ?b ?l))
            ; carrier not have this box assigned 
            (at start (not_assigned_carrier_box ?b ?cr))
            (over all (assigned_robot_carrier ?cr ?r))  ;; carrier have to be assigned this robot 
            (at start (carrier_capacity_3 ?cr))  ;; current capacity is 4 
            ; force nonconcurrency
            (at start (not_agent_occupied ?r))
            (at start (not_is_assigned_box ?b))
        )
        :effect (and
            ; now carrier has this box assigned 
            (at start (assigned_carrier_box ?b ?cr ))
            (at start
            	(not
                    (not_assigned_carrier_box ?b ?cr )
           	)
            )
            ; decrease capacity
            (at end (carrier_capacity_2 ?cr))
            (at start 
            	(not
                    (carrier_capacity_3 ?cr)
            	)
            )
            ; force nonconcurrency
            (at start  (agent_occupied ?r))
            (at end 
            	(not 
            	     (agent_occupied ?r)
            	)
            )
            (at start 
            	(not 
            	    (not_agent_occupied ?r)
            	)
            )
            (at end (not_agent_occupied ?r))
            ; box is now assigned
            (at start 
            	(not 
            	    (not_is_assigned_box ?b)
            	)
            )
            (at end (is_assigned_box ?b))
        )     
    )
    ; pick up when carrier capacity is 2
    (:durative-action pick_up_cc_2
        :parameters (?b - box ?cr - carrier ?l - generic_location ?r - robot)
        :duration(= ?duration 1)
        :condition (and
            ; robot, box and content in same location
            (over all (be_at_robot  ?l ?r))
            (over all (be_at_box ?b ?l))        
            ; carrier not have this box assigned 
            (at start (not_assigned_carrier_box ?b ?cr))
            (over all (assigned_robot_carrier  ?cr ?r))  ;; carrier have to be assigned this robot 
            (at start (carrier_capacity_2 ?cr))  ;; current capacity is 4 
            ; force nonconcurrency
            (at start (not_agent_occupied ?r))
            (at start (not_is_assigned_box ?b))
        )
        :effect (and
            ; now carrier has this box assigned 
            (at start (assigned_carrier_box ?b ?cr))
            (at start 
            	(not
                    (not_assigned_carrier_box ?b ?cr)
            	)
            )
            ; decrease capacity
            (at end (carrier_capacity_1 ?cr))
            (at start 
            	(not
                    (carrier_capacity_2 ?cr)
            	)
            )
            ; force nonconcurrency
            (at start (agent_occupied ?r))
            (at end 
            	(not 
            	    (agent_occupied ?r)
            	)
            )
            (at start 
            	(not 
            	    (not_agent_occupied ?r)
            	)
            )
            (at end (not_agent_occupied ?r))
            ; box is now assigned
            (at start 
            	(not 
            	    (not_is_assigned_box ?b)
            	)
            )
            (at end (is_assigned_box ?b))
        )     
    )
    ; pick up when carrier capacity is 1
    (:durative-action pick_up_cc_1
        :parameters (?b - box  ?cr - carrier ?l - generic_location ?r - robot)
        :duration(= ?duration 1)
        :condition (and
            ; robot, box and content in same location
            (over all (be_at_robot ?l ?r))
            (over all (be_at_box ?b ?l))       
            ; carrier not have this box assigned 
            (at start (not_assigned_carrier_box ?b ?cr))
            (over all (assigned_robot_carrier ?cr ?r))  ;; carrier have to be assigned this robot 
            (at start (carrier_capacity_1 ?cr))  ;; current capacity is 4 
            ; force nonconcurrency
            (at start (not_agent_occupied ?r))
            (at start (not_is_assigned_box ?b))
        )
        :effect (and
            ; now carrier has this box assigned 
            (at start (assigned_carrier_box ?b ?cr ))
            (at start 
            	(not
                    (not_assigned_carrier_box ?b ?cr )
            	)
            )
            ; decrease capacity
            (at end (carrier_capacity_0 ?cr))
            (at start 
                 (not
                     (carrier_capacity_1 ?cr)
            	)
            )
            ; force nonconcurrency
            (at start (agent_occupied ?r))
            (at end 
            	(not 
            	    (agent_occupied ?r)
            	)
            )
            (at start 
            	(not 
            	    (not_agent_occupied ?r)
            	)
            )
            (at end (not_agent_occupied ?r))
            ; box is now assigned
            (at start 
            	(not 
            	    (not_is_assigned_box ?b)
            	)
            )
            (at end (is_assigned_box ?b))
        )     
    )
    
    ; ACTION SECTION - handling boxes - drop box
    
    ; deliver with carry capacity 3
    (:durative-action drop_cc_3
        :parameters (?b - box   ?cr - carrier ?l - generic_location  ?r - robot)
        :duration(= ?duration 1)
        :condition (and
            ; handling position that must be the same for object involved
            (over all (be_at_robot ?l ?r))
            (over all (be_at_box ?b ?l))
            ; carrier must be assigned to robot 
            (over all (assigned_robot_carrier ?cr ?r))
            ; box must be assigned to carrier
            (at start (assigned_carrier_box ?b ?cr))  
            ; parte carrier
            (at start (carrier_capacity_3 ?cr))
            ; force nonconcurrency
            (at start (not_agent_occupied ?r))
        )
        :effect (and
            ; carrier has no more box assigned 
            (at start 
            	(not
                    (assigned_carrier_box  ?b ?cr)
            	)
            )  
            (at start (not_assigned_carrier_box ?b ?cr ))
            ; parte carrier
            (at start 
            	(not
                    (carrier_capacity_3 ?cr)
            	)
            ) 
            (at end (carrier_capacity_4 ?cr))
            ; force nonconcurrency
            (at start  (agent_occupied ?r))
            (at end (not (agent_occupied ?r)))
            (at start  (not (not_agent_occupied ?r)))
            (at end (not_agent_occupied ?r))
            ; box is no more assigned
            (at start 
            	(not
            	    (is_assigned_box ?b)
            	)
            )
            (at end (not_is_assigned_box ?b))

        )
    )
    ; deliver with carry capacity 2
    (:durative-action drop_cc_2
        :parameters (?b - box   ?cr - carrier ?l - generic_location ?r - robot  )
        :duration(= ?duration 1)
        :condition (and
            ; handling position that must be the same for object involved
            (over all (be_at_robot ?l ?r ))
            (over all (be_at_box ?b ?l))           
            ; carrier must be assigned to robot 
            (over all (assigned_robot_carrier ?cr ?r ))
            ; box must be assigned to carrier
            (at start (assigned_carrier_box ?b ?cr ))            
            ; parte carrier
            (at start (carrier_capacity_2 ?cr ))
            ; force nonconcurrency
            (at start (not_agent_occupied ?r))
        )
        :effect (and
            ; carrier has no more box assigned 
            (at start 
            	(not
                    (assigned_carrier_box ?b ?cr )
            	)
            )  
            (at start (not_assigned_carrier_box ?b ?cr ))
            ; parte carrier
            (at start 
            	(not
                    (carrier_capacity_2 ?cr)
            	)
            ) 
            (at end (carrier_capacity_3 ?cr))
            ; force nonconcurrency
            (at start  (agent_occupied ?r))
            (at end 
            	(not 
            	    (agent_occupied ?r)
            	)
            )
            (at start  
            	(not 
            	    (not_agent_occupied ?r)
            	)
            )
            (at end (not_agent_occupied ?r))
            ; box is no more assigned
            (at start 
            	(not
            	    (is_assigned_box ?b)
            	)
            )
            (at end (not_is_assigned_box ?b))

        )
    )
    ; deliver with carry capacity 1
    (:durative-action drop_cc_1
        :parameters ( ?b - box ?cr - carrier ?l - generic_location ?r - robot)
        :duration(= ?duration 1)
        :condition (and
            ; handling position that must be the same for object involved
            (at start (be_at_robot ?l ?r ))
            (at start (be_at_box ?b ?l))           
            ; carrier must be assigned to robot 
            (over all (assigned_robot_carrier ?cr ?r))
            ; box must be assigned to carrier
            (at start (assigned_carrier_box  ?b ?cr))
            ; parte carrier
            (at start (carrier_capacity_1 ?cr))
            ; force nonconcurrency
            (at start (not_agent_occupied ?r))
        )
        :effect (and
            ; carrier has no more box assigned 
            (at start 
            	(not
                    (assigned_carrier_box  ?b ?cr)
            	)
            )  
            (at start (not_assigned_carrier_box  ?b ?cr))
            ; parte carrier
            (at start 
                (not
                    (carrier_capacity_1 ?cr)
            	)
            ) 
            (at end (carrier_capacity_2 ?cr))
            ; force nonconcurrency
            (at start  (agent_occupied ?r))
            (at end 
            	(not 
            	    (agent_occupied ?r)
            	)
            )
            (at start 
            	(not 
            	    (not_agent_occupied ?r)
            	)
            )
            (at end (not_agent_occupied ?r))
            ; box is no more assigned
            (at start 
            	(not
            	    (is_assigned_box ?b)
            	)
            )
            (at end (not_is_assigned_box ?b))

        )
    )
    ; deliver with carry capacity 0
    (:durative-action drop_cc_0
        :parameters (?b - box  ?cr - carrier ?l - generic_location   ?r - robot )
        :duration(= ?duration 1)
        :condition (and
            ; handling position that must be the same for object involved
            (over all (be_at_robot ?l ?r ))
            (over all (be_at_box ?b ?l))
            ; carrier must be assigned to robot 
            (over all (assigned_robot_carrier ?cr ?r ))
            ; box must be assigned to carrier
            (at start (assigned_carrier_box ?b ?cr ))            
            ; parte carrier
            (at start (carrier_capacity_0 ?cr))
            ; force nonconcurrency
            (at start (not_agent_occupied ?r))
        )
        :effect (and
            ; carrier has no more box assigned 
            (at start 
                (not
                     (assigned_carrier_box  ?b ?cr )
            	)
            )  
            (at start (not_assigned_carrier_box ?b ?cr ))
            ; carrier capacity is updated
            (at start 
                (not
                    (carrier_capacity_0 ?cr)
            	)
            ) 
            (at end (carrier_capacity_1 ?cr))
            ; force nonconcurrency
            (at start  (agent_occupied ?r))
            (at end 
            	(not 
            	    (agent_occupied ?r)
            	)
            )
            (at start  
            	(not 
            	    (not_agent_occupied ?r)
            	)
            )
            (at end (not_agent_occupied ?r))
            ; box is no more assigned
            (at start 
            	(not
            	   (is_assigned_box ?b)
            	)
            )
            (at end (not_is_assigned_box ?b))
        )
    )
    
    ; ACTION SECTION - empty boxes
    
    ; empty box when person want food
    (:durative-action empty_food
        :parameters (?b - box ?c - food ?cr - carrier ?l - generic_location ?p - person  ?r - robot)
        :duration(= ?duration 1)
        :condition (and
            ; robot, box, content, person at same location
            (over all (be_at_robot  ?l ?r))
            (over all (be_at_box ?b ?l))
            (over all (be_at_content ?c ?l))
            (over all (be_at_person  ?l ?p))
            ; box contains content
            (at start (assigned_box_content ?b ?c))
            ;; box should not be contained in carrier (but instead delivered)
            (over all (not_assigned_carrier_box ?b ?cr ))
            ; force nonconcurrency
            (at start (not_agent_occupied ?r))
            ; box should not be assigned/carried by robots
            (at start (not_is_assigned_box ?b))
            ; receiver of content should want food
            (at start (not_satisfied_food ?p))
         )
        :effect (and
            ; box is no more related to content 
            (at start 
                (not
                    (assigned_box_content ?b ?c)
            	)
            )
            (at start (not_assigned_box_content ?b ?c))
            ; content is now assigned to person 
            (at end (assigned_person_content ?c ?p))
            (at end 
            	(not  
                    (not_assigned_person_content ?c ?p)
            	)
            )
            ; force nonconcurrency
            (at start (agent_occupied ?r))
            (at end (not (agent_occupied ?r)))
            (at start  
            	(not 
            	     (not_agent_occupied ?r)
            	)
            )
            (at end (not_agent_occupied ?r))
            (at end (empty_box ?b))
            (at end (not (not_satisfied_food ?p)))
            (at end (satisfied_food ?p))
        )
    )
    ; empty box when person want medicine
    (:durative-action empty_medicine
        :parameters (?b - box ?c - medicine ?cr - carrier ?l - generic_location ?p - person  ?r - robot)
        :duration(= ?duration 1)
        :condition (and
            ; robot, box, content, person at same location
            (over all (be_at_robot  ?l ?r))
            (over all (be_at_box ?b ?l))
            (over all (be_at_content ?c ?l))
            (over all (be_at_person  ?l ?p))
            ; box contains content
            (at start (assigned_box_content ?b ?c))
            ;; box should not be contained in carrier (but instead delivered)
            (over all (not_assigned_carrier_box ?b ?cr))
            ; force nonconcurrency
            (at start (not_agent_occupied ?r))
            ; box should not be assigned/carried by robots
            (at start (not_is_assigned_box ?b))
            ; receiver of content should want food
            (at start (not_satisfied_medicine ?p))
         )
        :effect (and
            ; box is no more related to content 
            (at start (not
                (assigned_box_content ?b ?c)
            ))
            (at start (not_assigned_box_content ?b ?c))
            ; content is now assigned to person 
            (at end (assigned_person_content  ?c ?p))
            (at end (not  
                (not_assigned_person_content  ?c ?p)
            ))
            ; force nonconcurrency
            (at start (agent_occupied ?r))
            (at end 
            	(not 
            	    (agent_occupied ?r)
            	)
            )
            (at start 
            	(not 
            	    (not_agent_occupied ?r)
            	)
            )
            (at end (not_agent_occupied ?r))
            (at end (empty_box ?b))
            (at end 
            	(not 
            	    (not_satisfied_medicine ?p)
            	)
            )
            (at end (satisfied_medicine ?p))
        )
    )
    ; empty box when person want tool
    (:durative-action empty_tool
        :parameters (?b - box ?c - tool ?cr - carrier ?l - generic_location ?p - person  ?r - robot)
        :duration(= ?duration 1)
        :condition (and
            ; robot, box, content, person at same location
            (over all (be_at_robot  ?l ?r))
            (over all (be_at_box ?b ?l))
            (over all (be_at_content ?c ?l))
            (over all (be_at_person  ?l ?p))
            ; box contains content
            (at start (assigned_box_content ?b ?c))
            ;; box should not be contained in carrier (but instead delivered)
            (over all (not_assigned_carrier_box ?b ?cr ))
            ; force nonconcurrency
            (at start (not_agent_occupied ?r))
            ; box should not be assigned/carried by robots
            (at start (not_is_assigned_box ?b))
            ; receiver of content should want food
            (at start (not_satisfied_tool ?p))
         )
        :effect (and
            ; box is no more related to content 
            (at start (not
                (assigned_box_content ?b ?c))
            )
            (at start (not_assigned_box_content ?b ?c))
            ; content is now assigned to person 
            (at end (assigned_person_content  ?c ?p))
            (at end 
            	(not  
                    (not_assigned_person_content  ?c ?p)
            	)
            )
            ; force nonconcurrency
            (at start (agent_occupied ?r))
            (at end 
            	(not 
            	    (agent_occupied ?r)
            	)
            )
            (at start 
            	(not 
            	    (not_agent_occupied ?r)
            	)
            )
            (at end (not_agent_occupied ?r))
            (at end (empty_box ?b))
            (at end 
            	(not 
            	    (not_satisfied_tool ?p)
            	)
            )
            (at end (satisfied_tool ?p))
        )
    )
    
    ; ACTION SECTION - handling movement 
    
    (:durative-action move_cc_4
        :parameters (?cr - carrier ?l1 - generic_location ?l2 - generic_location ?r - robot)
        :duration(= ?duration 2)
        :condition (and
            ; robot must be located at start 
            (at start (be_at_robot ?l1 ?r))
            ; robot must be empty
            (over all (carrier_capacity_4 ?cr))
            ; force nonconcurrency
            (at start (not_agent_occupied ?r))
        )
        :effect (and
            ; robot no more at start...
            (at start (not
                (be_at_robot ?l1 ?r)
            ))
            ; but it is at the end 
            (at end (be_at_robot ?l2 ?r ))
            ; force nonconcurrency
            (at start (agent_occupied ?r))
            (at end 
            	(not 
            	    (agent_occupied ?r)
            	)
            )
            (at start  
            	(not 
            	    (not_agent_occupied ?r)
            	)
            )
            (at end (not_agent_occupied ?r))
        )     
    )

    ; move when only single box carried 
    (:durative-action move_cc_3_wc
        :parameters (?b - box ?c - content ?cr - carrier ?l1 - generic_location ?l2 - location ?r - robot)
        :duration(= ?duration 2)
        :condition (and
            ; robot, box and content must be located at start 
            (at start (be_at_robot ?l1 ?r ))
            (at start (be_at_box ?b ?l1))
            (at start (be_at_content ?c ?l1))
            (over all (assigned_carrier_box ?b ?cr ))
            (over all (assigned_box_content ?b ?c))
            (over all (carrier_capacity_3 ?cr))
            ; force nonconcurrency
            (at start (not_agent_occupied ?r))
        )
        :effect (and
            ; update robot position 
            (at start 
            	(not
                    (be_at_robot ?l1 ?r)
            	)
            )
            (at end (be_at_robot ?l2 ?r))
            ; update content position
            (at start 
            	(not
                    (be_at_content ?c ?l1)
            	)
            )
            (at end (be_at_content ?c ?l2))
            ; update box position  
            (at start 
            	(not
                    (be_at_box ?b ?l1)
            	)
            )
            (at end (be_at_box ?b ?l2))
            ; force nonconcurrency
            (at start (agent_occupied ?r))
            (at end 
            	(not 
            	    (agent_occupied ?r)
            	)
            )
            (at start 
            	(not 
            	    (not_agent_occupied ?r)
            	)
            )
            (at end (not_agent_occupied ?r))
        )         
    )
    (:durative-action move_cc_3_noc
        :parameters (?b - box  ?cr - carrier ?l1 - generic_location ?l2 - generic_location ?r - robot)
        :duration(= ?duration 2)
        :condition (and
            ; robot, box and content must be located at start 
            (at start (be_at_robot ?l1 ?r ))
            (at start (be_at_box ?b ?l1))
            (over all (assigned_carrier_box ?b ?cr ))
            (over all (carrier_capacity_3 ?cr))
            ; force nonconcurrency
            (at start (not_agent_occupied ?r))
            (over all (empty_box ?b))          
        )
        :effect (and
            ; update robot position 
            (at start 
            	(not
                    (be_at_robot ?l1 ?r )
            	)
            )
            (at end (be_at_robot ?l2 ?r ))
            ; update box position  
            (at start 
            	(not
                    (be_at_box ?b ?l1)
            	)
            )
            (at end (be_at_box ?b ?l2))
            ; force nonconcurrency
            (at start (agent_occupied ?r))
            (at end 
            	(not 
            	    (agent_occupied ?r)
            	)
            )
            (at start 
            	(not 
            	    (not_agent_occupied ?r)
            	)
            )
            (at end (not_agent_occupied ?r))
        )         
    )
    
    
    ; move when two box carried 
    (:durative-action move_cc_2_wcwc
        :parameters ( ?b1 ?b2 - box ?c1 ?c2 - content ?cr - carrier ?l1 - generic_location ?l2 - location  ?r - robot)
        :duration(= ?duration 2)
        :condition (and
            ; robot, box and content must be located at start 
            (at start (be_at_robot ?l1 ?r ))
            ; boxe position
            (at start (be_at_box ?b1 ?l1))
            (at start (be_at_box ?b2 ?l1))
            ; contents position
            (at start (be_at_content ?c1 ?l1))
            (at start (be_at_content ?c2 ?l1))
            ; assignment carrier boxes 
            (over all (assigned_carrier_box  ?b1 ?cr))
            (over all (assigned_carrier_box  ?b2 ?cr))
            ; assignment box contents 
            (over all (assigned_box_content ?b1 ?c1))
            (over all (assigned_box_content ?b2 ?c2))
            (over all (carrier_capacity_2 ?cr))
            ; force nonconcurrency
            (at start (not_agent_occupied ?r))
        )
        :effect (and
            ; update robot position 
            (at start 
                (not
                    (be_at_robot ?l1 ?r)
            	)
            )
            (at end (be_at_robot ?l2 ?r))
            ; update contents position
            (at start 
                (not
                    (be_at_content ?c1 ?l1)
            	)
            )
            (at end (be_at_content ?c1 ?l2))
            (at start 
            	(not
                    (be_at_content ?c2 ?l1)
            	)
            )
            (at end (be_at_content ?c2 ?l2))
            ; update boxes position  
            (at start 
            	(not
                    (be_at_box ?b1 ?l1)
            	)
            )
            (at end (be_at_box ?b1 ?l2))
            (at start 
                (not
                    (be_at_box ?b2 ?l1)
            	)
            )
            (at end (be_at_box ?b2 ?l2))
            ; force nonconcurrency
            (at start (agent_occupied ?r))
            (at end 
                (not 
                    (agent_occupied ?r)
                )
            )
            (at start  
            	(not 
            	    (not_agent_occupied ?r)
            	)
            )
            (at end (not_agent_occupied ?r))
    	)            
    )
    ; move when two box carried 
    (:durative-action move_cc_2_wcnoc
        :parameters ( ?b1 ?b2 - box ?c1  - content ?cr - carrier ?l1 - generic_location ?l2 - location  ?r - robot)
        :duration(= ?duration 2)
        :condition (and
            ; robot, box and content must be located at start 
            (at start (be_at_robot ?l1 ?r))
            ; boxe position
            (at start (be_at_box ?b1 ?l1))
            (at start (be_at_box ?b2 ?l1))
            ;contents position
            (at start (be_at_content ?c1 ?l1))
            ;assignment carrier boxes 
            (over all (assigned_carrier_box  ?b1 ?cr))
            (over all (assigned_carrier_box  ?b2 ?cr))
            ;assignment box contents 
            (over all (assigned_box_content ?b1 ?c1))
            (over all (carrier_capacity_2 ?cr))
            ; force nonconcurrency
            (at start (not_agent_occupied ?r))            
            (over all (empty_box ?b2))
        )
        :effect (and
            ; update robot position 
            (at start 
            	(not
                    (be_at_robot ?l1 ?r)
            	)
            )
            (at end (be_at_robot ?l2 ?r))
            ; update contents position
            (at start 
            	(not
                    (be_at_content ?c1 ?l1)
            	)
            )
            (at end (be_at_content ?c1 ?l2))
            ; update boxes position  
            (at start 
            	(not
                    (be_at_box ?b1 ?l1)
            	)
            )
            (at end (be_at_box ?b1 ?l2))
            (at start 
            	(not
                    (be_at_box ?b2 ?l1)
            	)
            )
            (at end (be_at_box ?b2 ?l2))
            ; force nonconcurrency
            (at start (agent_occupied ?r))
            (at end 
            	(not 
            	    (agent_occupied ?r)
            	)
            )
            (at start 
            	(not 
            	    (not_agent_occupied ?r)
            	)
            )
            (at end (not_agent_occupied ?r))
    	)            
    )
    ; move when two box carried 
    (:durative-action move_cc_2_nocnoc
        :parameters ( ?b1 ?b2 - box ?cr - carrier ?l1 - generic_location ?l2 - generic_location  ?r - robot)
        :duration(= ?duration 2)
        :condition (and
            ; robot, box and content must be located at start 
            (at start (be_at_robot ?l1 ?r ))
            ; boxe position
            (at start (be_at_box ?b1 ?l1))
            (at start (be_at_box ?b2 ?l1))
            ; assignment carrier boxes 
            (over all (assigned_carrier_box  ?b1 ?cr))
            (over all (assigned_carrier_box  ?b2 ?cr))
            (over all (carrier_capacity_2 ?cr))
            ; force nonconcurrency
            (at start (not_agent_occupied ?r))            
            (over all (empty_box ?b1))
            (over all (empty_box ?b2))
        )
        :effect (and
            ; update robot position 
            (at start 
                (not
                    (be_at_robot ?l1 ?r)
            	)
            )
            (at end (be_at_robot ?l2 ?r))                        
            ; update boxes position  
            (at start 
            	(not
                    (be_at_box ?b1 ?l1)
            	)
            )
            (at end (be_at_box ?b1 ?l2))
            (at start 
            	(not
                    (be_at_box ?b2 ?l1)
            	)
            )
            (at end (be_at_box ?b2 ?l2))
            ; force nonconcurrency
            (at start (agent_occupied ?r))
            (at end 
            	(not 
            	    (agent_occupied ?r)
            	)
            )
            (at start  
            	(not 
            	    (not_agent_occupied ?r)
            	)
            )
            (at end (not_agent_occupied ?r))
    	)            
    )
    
    
    ; move when three box carried 
    (:durative-action move_cc_1_wcwcwc
        :parameters ( ?b1 ?b2 ?b3 - box ?c1 ?c2 ?c3 - content ?cr - carrier ?l1 - generic_location ?l2 - location ?r - robot)
        :duration(= ?duration 2)
        :condition (and
            ; robot, box and content must be located at start 
            (at start (be_at_robot ?l1 ?r))
            ; boxe position
            (at start (be_at_box ?b1 ?l1))
            (at start (be_at_box ?b2 ?l1))
            (at start (be_at_box ?b3 ?l1))
            ; contents position
            (at start (be_at_content ?c1 ?l1))
            (at start (be_at_content ?c2 ?l1))
            (at start (be_at_content ?c3 ?l1))
            ; assignment carrier boxes 
            (over all (assigned_carrier_box ?b1 ?cr))
            (over all (assigned_carrier_box  ?b2 ?cr))
            (over all (assigned_carrier_box  ?b3 ?cr))
            ;assignment box contents 
            (over all (assigned_box_content ?b1 ?c1))
            (over all (assigned_box_content ?b2 ?c2))
            (over all (assigned_box_content ?b3 ?c3))
            (over all (carrier_capacity_1 ?cr))
            ; force nonconcurrency
            (at start (not_agent_occupied ?r))
        )
        :effect (and
            ; update robot position 
            (at start 
            	(not
                    (be_at_robot ?l1 ?r)
            	)
            )
            (at end (be_at_robot ?l2 ?r))
            ; update contents position
            (at start 
            	(not
                    (be_at_content ?c1 ?l1)
            	)
            )
            (at end (be_at_content ?c1 ?l2))
            (at start 
            	(not
                    (be_at_content ?c2 ?l1)
            	)
            )
            (at end (be_at_content ?c2 ?l2))
            (at start 
            	(not
                    (be_at_content ?c3 ?l1)
            	)
            )
            (at end (be_at_content ?c3 ?l2))
            ; update boxes position  
            (at start 
            	(not
                    (be_at_box ?b1 ?l1)
            	)
            )
            (at end (be_at_box ?b1 ?l2))
            (at start 
            	(not
                    (be_at_box ?b2 ?l1)
            	)
            )
            (at end (be_at_box ?b2 ?l2))
            (at start 
            	(not
                    (be_at_box ?b3 ?l1)
            	)
            )
            (at end (be_at_box ?b3 ?l2))
            ; force nonconcurrency
            (at start (agent_occupied ?r))
            (at end 
            	(not 
            	    (agent_occupied ?r)
            	)
            )
            (at start  
            	(not 
            	    (not_agent_occupied ?r)
            	)
            )
            (at end (not_agent_occupied ?r))
        )         
    )
    ; move when three box carried 
    (:durative-action move_cc_1_wcwcnoc
        :parameters ( ?b1 ?b2 ?b3 - box ?c1 ?c2  - content ?cr - carrier ?l1 - generic_location ?l2 - location ?r - robot)
        :duration(= ?duration 2)
        :condition (and            
            ; robot, box and content must be located at start 
            (at start (be_at_robot ?l1 ?r ))
            ; boxe position
            (at start (be_at_box ?b1 ?l1))
            (at start (be_at_box ?b2 ?l1))
            (at start (be_at_box ?b3 ?l1))
            ; contents position
            (at start (be_at_content ?c1 ?l1))
            (at start (be_at_content ?c2 ?l1))

            ; assignment carrier boxes 
            (over all (assigned_carrier_box ?b1 ?cr ))
            (over all (assigned_carrier_box  ?b2 ?cr))
            (over all (assigned_carrier_box  ?b3 ?cr))
            ;assignment box contents 
            (over all (assigned_box_content ?b1 ?c1))
            (over all (assigned_box_content ?b2 ?c2))
            (over all (carrier_capacity_1 ?cr))
            ; force nonconcurrency
            (at start (not_agent_occupied ?r))            
            (over all (empty_box ?b3))
        )
        :effect (and
            ; update robot position 
            (at start 
            	(not
                    (be_at_robot ?l1 ?r )
            	)
            )
            (at end (be_at_robot ?l2 ?r ))
            ; update contents position
            (at start 
            	(not
                    (be_at_content ?c1 ?l1)
            	)
            )
            (at end (be_at_content ?c1 ?l2))
            (at start 
            	(not
                    (be_at_content ?c2 ?l1)
            	)
            )
            (at end (be_at_content ?c2 ?l2))
            ; update boxes position  
            (at start 
            	(not
                    (be_at_box ?b1 ?l1)
            	)
            )
            (at end (be_at_box ?b1 ?l2))
            (at start 
            	(not
                    (be_at_box ?b2 ?l1)
            	)
            )
            (at end (be_at_box ?b2 ?l2))
            (at start 
            	(not
                    (be_at_box ?b3 ?l1)
            	)
            )
            (at end (be_at_box ?b3 ?l2))
            ; force nonconcurrency
            (at start (agent_occupied ?r))
            (at end 
            	(not
            	    (agent_occupied ?r)
            	)
            )
            (at start  
            	(not 
            	    (not_agent_occupied ?r)
            	)
            )
            (at end (not_agent_occupied ?r))
        )         
    )
    ; move when three box carried 
    (:durative-action move_cc_1_wcnocnoc
        :parameters (?b1 ?b2 ?b3 - box ?c1  - content ?cr - carrier ?l1 - generic_location ?l2 - location ?r - robot)
        :duration(= ?duration 2)
        :condition (and                        
            ; robot, box and content must be located at start 
            (at start (be_at_robot ?l1 ?r ))
            ; boxe position
            (at start (be_at_box ?b1 ?l1))
            (at start (be_at_box ?b2 ?l1))
            (at start (be_at_box ?b3 ?l1))
            ; contents position
            (at start (be_at_content ?c1 ?l1))
            ; assignment carrier boxes 
            (over all (assigned_carrier_box ?b1 ?cr))
            (over all (assigned_carrier_box ?b2 ?cr))
            (over all (assigned_carrier_box ?b3 ?cr))
            ; assignment box contents 
            (over all (assigned_box_content ?b1 ?c1))
            (over all (carrier_capacity_1 ?cr))
            ; force nonconcurrency
            (at start (not_agent_occupied ?r))            
            (over all (empty_box ?b2))
            (over all (empty_box ?b3))
        )
        :effect (and
            ; update robot position 
            (at start 
            	(not
                    (be_at_robot ?l1 ?r)
            	)
            )
            (at end (be_at_robot ?l2 ?r))
            ; update contents position
            (at start 
            	(not
                    (be_at_content ?c1 ?l1)
            	)
            )
            (at end (be_at_content ?c1 ?l2))       
            ; update boxes position  
            (at start 
            	(not
                    (be_at_box ?b1 ?l1)
            	)
            )
            (at end (be_at_box ?b1 ?l2))
            (at start 
            	(not
                    (be_at_box ?b2 ?l1)
            	)
            )
            (at end (be_at_box ?b2 ?l2))
            (at start 
            	(not
                    (be_at_box ?b3 ?l1)
            	)
            )
            (at end (be_at_box ?b3 ?l2))
            ; force nonconcurrency
            (at start (agent_occupied ?r))
            (at end 
            	(not 
            	    (agent_occupied ?r)
            	)
            )
            (at start 
            	(not 
            	    (not_agent_occupied ?r)
            	)
            )
            (at end (not_agent_occupied ?r))
        )         
    )
    ; move when three box carried 
    (:durative-action move_cc_1_nocnocnoc
        :parameters (?b1 ?b2 ?b3 - box  ?cr - carrier ?l1 - generic_location ?l2 - generic_location ?r - robot)
        :duration(= ?duration 2)
        :condition (and                        
            ; robot, box and content must be located at start 
            (at start (be_at_robot ?l1 ?r))
            ; boxe position
            (at start (be_at_box ?b1 ?l1))
            (at start (be_at_box ?b2 ?l1))
	    (at start (be_at_box ?b3 ?l1))
            ;assignment carrier boxes 
            (over all (assigned_carrier_box ?b1 ?cr))
            (over all (assigned_carrier_box ?b2 ?cr))
            (over all (assigned_carrier_box ?b3 ?cr))
            (over all (carrier_capacity_1 ?cr))
            ; force nonconcurrency
            (at start (not_agent_occupied ?r))            
            (over all (empty_box ?b1))
            (over all (empty_box ?b2))
            (over all (empty_box ?b3))
        )
        :effect (and
            ; update robot position 
            (at start 
            	(not
                    (be_at_robot ?l1 ?r)
            	)
            )
            (at end (be_at_robot ?l2 ?r))    
            ; update boxes position  
            (at start 
            	(not
                    (be_at_box ?b1 ?l1)
            	)
            )
            (at end (be_at_box ?b1 ?l2))
            (at start 
            	(not
                    (be_at_box ?b2 ?l1)
            	)
            )
            (at end (be_at_box ?b2 ?l2))
            (at start 
            	(not
                    (be_at_box ?b3 ?l1)
            	)
            )
            (at end (be_at_box ?b3 ?l2))
            ; force nonconcurrency
            (at start (agent_occupied ?r))
            (at end 
            	(not 
            	    (agent_occupied ?r)
            	)
            )
            (at start 
            	(not 
            	    (not_agent_occupied ?r)
            	)
            )
            (at end (not_agent_occupied ?r))
        )         
    )
    
    
    ; move when four box carried 
    ; here is possible to move to generic location as result of movement (return to depot)
    (:durative-action move_cc_0_wcwcwcwc
        :parameters (?b1 ?b2 ?b3 ?b4 - box ?c1 ?c2 ?c3 ?c4 - content ?cr - carrier ?l1 - generic_location ?l2 - location ?r - robot)
        :duration(= ?duration 2)
        :condition (and          
            ; robot, box and content must be located at start 
            (at start (be_at_robot ?l1 ?r ))
            ; boxe position
            (at start (be_at_box ?b1 ?l1))
            (at start (be_at_box ?b2 ?l1))
            (at start (be_at_box ?b3 ?l1))
            (at start (be_at_box ?b4 ?l1))
            ; contents position
            (at start (be_at_content ?c1 ?l1))
            (at start (be_at_content ?c2 ?l1))
            (at start (be_at_content ?c3 ?l1))
            (at start (be_at_content ?c4 ?l1))
            ; assignment carrier boxes 
            (over all (assigned_carrier_box ?b1 ?cr))
            (over all (assigned_carrier_box ?b2 ?cr))
            (over all (assigned_carrier_box ?b3 ?cr))
            (over all (assigned_carrier_box ?b4 ?cr))
            ; assignment box contents 
            (over all (assigned_box_content ?b1 ?c1))
            (over all (assigned_box_content ?b2 ?c2))
            (over all (assigned_box_content ?b3 ?c3))
            (over all (assigned_box_content ?b4 ?c4))
            (over all (carrier_capacity_0 ?cr))
            ; force nonconcurrency
            (at start (not_agent_occupied ?r))
        )
        :effect (and
            ; update robot position 
            (at start 
            	(not
                    (be_at_robot ?l1 ?r)
            	)
            )
            (at end (be_at_robot  ?l2 ?r))
            ; update contents position
            (at start 
            	(not
                   (be_at_content ?c1 ?l1)
                )
            )
            (at end (be_at_content ?c1 ?l2))
            (at start 
            	(not
                    (be_at_content ?c2 ?l1)
            	)
            )
            (at end (be_at_content ?c2 ?l2))
            (at start 
            	(not
                   (be_at_content ?c3 ?l1)
            	)
            )
            (at end (be_at_content ?c3 ?l2))
            (at start 
            	(not
                    (be_at_content ?c4 ?l1)
            	)
            )
            (at end (be_at_content ?c4 ?l2))
            ; update boxes position  
            (at start 
            	(not
                    (be_at_box ?b1 ?l1)
            	)
            )
            (at end (be_at_box ?b1 ?l2))
            (at start 
            	(not
                    (be_at_box ?b2 ?l1)
            	)
            )
            (at end (be_at_box ?b2 ?l2))
            (at start 
            	(not
                    (be_at_box ?b3 ?l1)
            	)
            )
            (at end (be_at_box ?b3 ?l2))
            (at start 
            	(not
                    (be_at_box ?b4 ?l1)
            	)
            )
            (at end (be_at_box ?b4 ?l2))
            ; force nonconcurrency
            (at start (agent_occupied ?r))
            (at end 
            	(not 
            	    (agent_occupied ?r)
            	)
            )
            (at start  
            	(not 
            	    (not_agent_occupied ?r)
            	)
            )
            (at end (not_agent_occupied ?r))
        )         
    )
    (:durative-action move_cc_0_wcwcwcnoc
        :parameters (?b1 ?b2 ?b3 ?b4 - box ?c1 ?c2 ?c3  - content ?cr - carrier ?l1 - generic_location ?l2 - location ?r - robot)
        :duration(= ?duration 2)
        :condition (and            
            ; robot, box and content must be located at start 
            (at start (be_at_robot ?l1 ?r))
            ; boxe position
            (at start (be_at_box ?b1 ?l1))
            (at start (be_at_box ?b2 ?l1))
            (at start (be_at_box ?b3 ?l1))
            (at start (be_at_box ?b4 ?l1))
            ; contents position
            (at start (be_at_content ?c1 ?l1))
            (at start (be_at_content ?c2 ?l1))
            (at start (be_at_content ?c3 ?l1))
            ; assignment carrier boxes 
            (over all (assigned_carrier_box ?b1 ?cr))
            (over all (assigned_carrier_box ?b2 ?cr))
            (over all (assigned_carrier_box ?b3 ?cr))
            (over all (assigned_carrier_box ?b4 ?cr))
            ; assignment box contents 
            (over all (assigned_box_content ?b1 ?c1))
            (over all (assigned_box_content ?b2 ?c2))
            (over all (assigned_box_content ?b3 ?c3))
            (over all (carrier_capacity_0 ?cr))
            ; force nonconcurrency
            (at start (not_agent_occupied ?r))                       
            (over all (empty_box ?b4))
        )
        :effect (and
            ; update robot position 
            (at start 
                (not
                    (be_at_robot ?l1 ?r)
            	)
            )
            (at end (be_at_robot  ?l2 ?r))
            ; update contents position
            (at start 
            	(not
                    (be_at_content ?c1 ?l1)
            	)
            )
            (at end (be_at_content ?c1 ?l2))
            (at start 
            	(not
                    (be_at_content ?c2 ?l1)
            	)
            )
            (at end (be_at_content ?c2 ?l2))
            (at start 
                (not
                    (be_at_content ?c3 ?l1)
            	)
            )
            (at end (be_at_content ?c3 ?l2))
            ; update boxes position  
            (at start 
            	(not
                    (be_at_box ?b1 ?l1)
            	)
            )
            (at end (be_at_box ?b1 ?l2))
            (at start 
            	(not
                    (be_at_box ?b2 ?l1)
            	)
            )
            (at end (be_at_box ?b2 ?l2))
            (at start 
                (not
                    (be_at_box ?b3 ?l1)
            	)
            )
            (at end (be_at_box ?b3 ?l2))
            (at start 
             	(not
                    (be_at_box ?b4 ?l1)
            	)
            )
            (at end (be_at_box ?b4 ?l2))
            ; force nonconcurrency
            (at start (agent_occupied ?r))
            (at end 
            	(not 
            	    (agent_occupied ?r)
            	)
            )
            (at start  
            	(not 
            	    (not_agent_occupied ?r)
            	)
            )
            (at end (not_agent_occupied ?r))
        )         
    )
    (:durative-action move_cc_0_wcwcnocnoc
        :parameters (?b1 ?b2 ?b3 ?b4 - box ?c1 ?c2  - content ?cr - carrier ?l1 - generic_location ?l2 - location ?r - robot)
        :duration(= ?duration 2)
        :condition (and         
            ; robot, box and content must be located at start 
            (at start (be_at_robot ?l1 ?r ))
            ; boxe position
            (at start (be_at_box ?b1 ?l1))
            (at start (be_at_box ?b2 ?l1))
            (at start (be_at_box ?b3 ?l1))
            (at start (be_at_box ?b4 ?l1))
            ; contents position
            (at start (be_at_content ?c1 ?l1))
            (at start (be_at_content ?c2 ?l1))
            ; assignment carrier boxes 
            (over all (assigned_carrier_box ?b1 ?cr))
            (over all (assigned_carrier_box ?b2 ?cr))
            (over all (assigned_carrier_box ?b3 ?cr))
            (over all (assigned_carrier_box ?b4 ?cr))
            ; assignment box contents 
            (over all (assigned_box_content ?b1 ?c1))
            (over all (assigned_box_content ?b2 ?c2))
            (over all (carrier_capacity_0 ?cr))
            ; force nonconcurrency
            (at start (not_agent_occupied ?r))            
            (over all (empty_box ?b3))
            (over all (empty_box ?b4))
        )
        :effect (and
            ; update robot position 
            (at start 
            	(not
                    (be_at_robot ?l1 ?r)
            	)
            )
            (at end (be_at_robot  ?l2 ?r))
            ; update contents position
            (at start 
            	(not
                    (be_at_content ?c1 ?l1)
            	)
            )
            (at end (be_at_content ?c1 ?l2))
            (at start 
            	(not
                    (be_at_content ?c2 ?l1)
            	)
            )
            (at end (be_at_content ?c2 ?l2))           
            ; update boxes position  
            (at start 
                (not
                    (be_at_box ?b1 ?l1)
            	)
            )
            (at end (be_at_box ?b1 ?l2))
            (at start 
                (not
                    (be_at_box ?b2 ?l1)
                )
            )
            (at end (be_at_box ?b2 ?l2))
            (at start 
                (not
                    (be_at_box ?b3 ?l1)
            	)
            )
            (at end (be_at_box ?b3 ?l2))
            (at start 
            	(not
                    (be_at_box ?b4 ?l1)
            	)
            )	
            (at end (be_at_box ?b4 ?l2))
            ; force nonconcurrency
            (at start (agent_occupied ?r))
            (at end 
            	(not 
            	    (agent_occupied ?r)
            	)
            )
            (at start 
            	(not 
            	    (not_agent_occupied ?r)
            	)
            )
            (at end (not_agent_occupied ?r))
        )         
    )
    (:durative-action move_cc_0_wcnocnocnoc
        :parameters (?b1 ?b2 ?b3 ?b4 - box ?c1 - content ?cr - carrier ?l1 - generic_location ?l2 - location ?r - robot)
        :duration(= ?duration 2)
        :condition (and               
            ; robot, box and content must be located at start 
            (at start (be_at_robot ?l1 ?r))
            ; boxe position
            (at start (be_at_box ?b1 ?l1))
            (at start (be_at_box ?b2 ?l1))
            (at start (be_at_box ?b3 ?l1))
            (at start (be_at_box ?b4 ?l1))
            ; contents position
            (at start (be_at_content ?c1 ?l1))
            ; assignment carrier boxes 
            (over all (assigned_carrier_box ?b1 ?cr))
            (over all (assigned_carrier_box ?b2 ?cr))
            (over all (assigned_carrier_box ?b3 ?cr))
            (over all (assigned_carrier_box ?b4 ?cr))
            ; assignment box contents 
            (over all (assigned_box_content ?b1 ?c1))
            (over all (carrier_capacity_0 ?cr))
            ; force nonconcurrency
            (at start (not_agent_occupied ?r))            
            (over all (empty_box ?b2))
            (over all (empty_box ?b3))
            (over all (empty_box ?b4))
        )
        :effect (and
            ; update robot position 
            (at start 
            	(not
                    (be_at_robot ?l1 ?r )
            	)
            )
            (at end (be_at_robot  ?l2 ?r))
            ; update contents position
            (at start 
            	(not
                    (be_at_content ?c1 ?l1)
            	)
            )
            (at end (be_at_content ?c1 ?l2))            
            ; update boxes position  
            (at start 
            	(not
                    (be_at_box ?b1 ?l1)
            	)
            )
            (at end (be_at_box ?b1 ?l2))
            (at start 
            	(not
                    (be_at_box ?b2 ?l1)
            	)
            )
            (at end (be_at_box ?b2 ?l2))
            (at start 
            	(not
                    (be_at_box ?b3 ?l1)
            	)
            )
            (at end (be_at_box ?b3 ?l2))
            (at start 
            	(not
                    (be_at_box ?b4 ?l1)
            	)
            )
            (at end (be_at_box ?b4 ?l2))
            ; force nonconcurrency
            (at start  (agent_occupied ?r))
            (at end 
            	(not 
            	    (agent_occupied ?r)
            	)
            )
            (at start  
            	(not 
            	    (not_agent_occupied ?r)
            	)
            )
            (at end (not_agent_occupied ?r))
        )         
    )
    (:durative-action move_cc_0_nocnocnocnoc
        :parameters (?b1 ?b2 ?b3 ?b4 - box ?cr - carrier ?l1 - generic_location ?l2 - generic_location ?r - robot)
        :duration(= ?duration 2)
        :condition (and            
            ; robot, box and content must be located at start 
            (at start (be_at_robot ?l1 ?r))
            ; boxe position
            (at start (be_at_box ?b1 ?l1))
            (at start (be_at_box ?b2 ?l1))
            (at start (be_at_box ?b3 ?l1))
            (at start (be_at_box ?b4 ?l1))
            ; assignment carrier boxes 
            (over all (assigned_carrier_box ?b1 ?cr))
            (over all (assigned_carrier_box ?b2 ?cr))
            (over all (assigned_carrier_box ?b3 ?cr))
            (over all (assigned_carrier_box ?b4 ?cr))
            (over all (carrier_capacity_0 ?cr))
            ; force nonconcurrency
            (at start (not_agent_occupied ?r))            
            (over all (empty_box ?b1))
            (over all (empty_box ?b2))
            (over all (empty_box ?b3))
            (over all (empty_box ?b4))
        )
        :effect (and
            ; update robot position 
            (at start 
            	(not
                    (be_at_robot ?l1 ?r)
            	)
            )
            (at end (be_at_robot ?l2 ?r))
            ; update boxes position  
            (at start 
            	(not
                    (be_at_box ?b1 ?l1)
            	)
            )
            (at end (be_at_box ?b1 ?l2))
            (at start 
            	(not
                    (be_at_box ?b2 ?l1)
            	)
            )
            (at end (be_at_box ?b2 ?l2))
            (at start 
            	(not
                    (be_at_box ?b3 ?l1)
            	)
            )
            (at end (be_at_box ?b3 ?l2))
            (at start 
            	(not
                    (be_at_box ?b4 ?l1)
                )
            )
            (at end (be_at_box ?b4 ?l2))
            ; force nonconcurrency
            (at start  (agent_occupied ?r))
            (at end
            	(not 
            	    (agent_occupied ?r)
            	)
            )
            (at start  
            	(not 
            	    (not_agent_occupied ?r)
            	)
            )
            (at end (not_agent_occupied ?r))
        )         
    )

)
