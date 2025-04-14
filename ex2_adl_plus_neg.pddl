; AUTHOR: Dimitri Vinci
; BRIEF DESCRIPTION:
; Domain for ex2 of APTP exam project,  non numerical version
; PLANNING VERSION: Classical planning, PDDL 2.1/2.2
; REQUIRE: strips + typing + equality + adl + negative precondition

(define 
    
    ; DOMAIN AND REQUIREMENTS SECTION

    (domain ex2_adl_plus_neg)
    
    (:requirements 
        :strips :typing :equality 
        :negative-preconditions
        :conditional-effects :existential-preconditions :disjunctive-preconditions :universal-preconditions :adl
    )
    
    ; TYPES AND PREDICATES SECTION
    
    (:types 
        person box robot content - object  
        ; to handle not returning to depot
        generic_location - object
        location - generic_location
        depot - generic_location
        medicine tool food - content ;; subclassed content
        carrier - object ;; carrier of robot 
    )
    
    (:predicates
        ; position
        (be_at_person ?l - generic_location ?p - person ) ;; true if person is in a given location
        (be_at_box ?b - box ?l - generic_location) ;; true if box is in a given location
        (be_at_content ?c - content ?l - generic_location)  ;; true if content is in a given location
        (be_at_robot ?l - generic_location ?r - robot )  ;; true if content is in a given location
        ; handle relation between object
        ; box
        (empty_box ?b - box)  ;; true if box not partecipate in any assigned_box_content predicate 
        (assigned_box_content ?b - box ?c - content) ;; true if a box contain a content
        ; person
        (assigned_person_content ?c - content ?p - person ) ;; true if a person has assigned a content
        ; robot
        (assigned_robot_carrier ?c - carrier ?r - robot )  ;; true if robot is carrying an object
        ; content
        (is_assigned ?c - content) ;; true if a content partecipate in at least one assigned assigned_box_content predicate
        ; carrier
        (assigned_carrier_box ?b - box ?c - carrier )
        ; to handle carrier capacity
        (carrier_capacity_0 ?c - carrier)
        (carrier_capacity_1 ?c - carrier)
        (carrier_capacity_2 ?c - carrier)
        (carrier_capacity_3 ?c - carrier)
        (carrier_capacity_4 ?c - carrier)
    )
    
    ; ACTION SECTION
    
    ; ACTION SECTION - handling boxes 
    
    (:action fill_box
        :parameters ( ?b - box ?c - content ?l - generic_location ?r - robot)
        :precondition (and
            ; robot, box and content in same location
            (be_at_robot  ?l ?r)
            (be_at_box ?b ?l)
            (be_at_content ?c ?l)
            ; no content assigned to box
            (forall (?c1 - content)    
                (not
                	(assigned_box_content ?b ?c1)
                )
            )
            ; no box assigned to content
            (forall (?b1 - box) 

                (not
                	(assigned_box_content ?b1 ?c)
                )
            )
            ; no content assigned to person
            (forall (?p - person) 
                (not
                	(assigned_person_content ?c ?p)
                )
            )   
            ; no carrier has this box assigned
            (forall (?cr1 - carrier) 
            	(not
            		(assigned_carrier_box ?b ?cr1)
            	)
            )   
        )
        :effect (and
            ; after fill the box, the box no more empty 
            (not
                (empty_box ?b)
            )
            ; the content is then assigned  (ant set its negated corresponding predicate)
            (is_assigned ?c)    
            ; box is now assigned 
            (assigned_box_content ?b ?c)
        )     
    )     
    
    ; ACTION SECTION - handling boxes - pick up
    ; pick up when carrier capacity is 4
    (:action pick_up_cc_4
        :parameters (?b - box  ?cr - carrier ?l - generic_location  ?r - robot)
        :precondition (and
            ; robot, box and content in same location
            (be_at_robot ?l ?r)
            (be_at_box ?b ?l)
            (assigned_robot_carrier  ?cr ?r) ;; carrier have to be assigned this robot 
            (carrier_capacity_4 ?cr) ;; current capacity is 4 
            (forall (?cr1 - carrier)
            	(not
            		(assigned_carrier_box ?b ?cr1)
            	)
            )
        )
        :effect (and
            ; now carrier has this box assigned 
            (assigned_carrier_box ?b ?cr)
    
            ; decrease capacity
            (carrier_capacity_3 ?cr)
            (not
                 (carrier_capacity_4 ?cr)
            )
        )     
    )
    ; pick up when carrier capacity is 3
    (:action pick_up_cc_3
        :parameters (?b - box ?cr - carrier ?l - generic_location  ?r - robot)
        :precondition (and
            ; robot, box and content in same location
            (be_at_robot ?l ?r)
            (be_at_box ?b ?l)                
            (assigned_robot_carrier  ?cr ?r) ;; carrier have to be assigned this robot 
            (carrier_capacity_3 ?cr) ;; current capacity is 4 
            (forall (?cr1 - carrier)
            	(not
            		(assigned_carrier_box ?b ?cr1)
            	)
            )
        )
        :effect (and
            ; now carrier has this box assigned 
            (assigned_carrier_box ?b ?cr) 
            ; decrease capacity
            (carrier_capacity_2 ?cr)
            (not
                 (carrier_capacity_3 ?cr)
            )
        )     
    )
    ; pick up when carrier capacity is 2
    (:action pick_up_cc_2
        :parameters ( ?b - box ?cr - carrier ?l - generic_location  ?r - robot)
        :precondition (and
            ; robot, box and content in same location
            (be_at_robot ?l ?r )
            (be_at_box ?b ?l)
            (assigned_robot_carrier  ?cr ?r   ) ;; carrier have to be assigned this robot 
            (carrier_capacity_2 ?cr) ;; current capacity is 4 
            (forall (?cr1 - carrier)
            	(not
            		(assigned_carrier_box ?b ?cr1 )
            	)
            )
        )
        :effect (and
            ; now carrier has this box assigned 
            (assigned_carrier_box ?b ?cr )
         
            ; decrease capacity
            (carrier_capacity_1 ?cr)
            (not
                 (carrier_capacity_2 ?cr)
            )
        )     
    )
    ; pick up when carrier capacity is 1
    (:action pick_up_cc_1
        :parameters (?b - box ?cr - carrier ?l - generic_location ?r - robot)
        :precondition (and
            ; robot, box and content in same location
            (be_at_robot ?l ?r )
            (be_at_box ?b ?l)       
            (assigned_robot_carrier ?cr ?r   ) ;; carrier have to be assigned this robot 
            (carrier_capacity_1 ?cr) ;; current capacity is 4 
            ; box should not be contained in carrier (but instead delivered)
            (forall (?cr1 - carrier)
            	(not
            		(assigned_carrier_box ?b ?cr1)
            	)
            )
        )
        :effect (and
            ; now carrier has this box assigned 
            (assigned_carrier_box ?b ?cr )
    
            ; decrease capacity
            (carrier_capacity_0 ?cr)
            (not
                 (carrier_capacity_1 ?cr)
            )
        )     
    )
    
    ; ACTION SECTION - handling boxes - deliver
    ; deliver with carry capacity 3
    (:action drop_cc_3
        :parameters ( ?b - box ?cr - carrier ?l - generic_location  ?r - robot)
        :precondition (and
            ; handling position that must be the same for object involved
            (be_at_robot ?l ?r)
            (be_at_box ?b ?l)
            ; carrier must be assigned to robot 
            (assigned_robot_carrier  ?cr ?r)
            ; box must be assigned to carrier
            (assigned_carrier_box ?b ?cr)            
            ; parte carrier
            (carrier_capacity_3 ?cr)
        )
        :effect (and
            ; carrier has no more box assigned 
            (not
                (assigned_carrier_box  ?b ?cr)
            )  
            ; parte carrier
            (not
                (carrier_capacity_3 ?cr)
            ) 
            (carrier_capacity_4 ?cr)
        )
    )
    ; deliver with carry capacity 2
    (:action drop_cc_2
        :parameters (?b - box ?cr - carrier ?l - generic_location ?r - robot)
        :precondition (and
            ; handling position that must be the same for object involved
            (be_at_robot ?l ?r )
            (be_at_box ?b ?l)
            ; carrier must be assigned to robot 
            (assigned_robot_carrier ?cr ?r)
            ; box must be assigned to carrier
            (assigned_carrier_box ?b ?cr)            
            ; parte carrier
            (carrier_capacity_2 ?cr)
        )
        :effect (and
            ; carrier has no more box assigned 
            (not
                (assigned_carrier_box ?b ?cr)
            )  
            ; parte carrier
            (not
                (carrier_capacity_2 ?cr)
            ) 
            (carrier_capacity_3 ?cr)
        )
    )
    ; deliver with carry capacity 1
    (:action drop_cc_1
        :parameters (?b - box ?cr - carrier ?l - generic_location ?r - robot)
        :precondition (and
            ; handling position that must be the same for object involved
            (be_at_robot ?l ?r )
            (be_at_box ?b ?l)
            ; carrier must be assigned to robot 
            (assigned_robot_carrier ?cr ?r)
            ; box must be assigned to carrier
            (assigned_carrier_box ?b ?cr)            
            ; parte carrier
            (carrier_capacity_1 ?cr)
        )
        :effect (and
            ; carrier has no more box assigned 
            (not
                (assigned_carrier_box  ?b ?cr)
            )  
            ; parte carrier
            (not
                (carrier_capacity_1 ?cr)
            ) 
            (carrier_capacity_2 ?cr)

        )
    )
    ; deliver with carry capacity 0
    (:action drop_cc_0
        :parameters ( ?b - box ?cr - carrier ?l - generic_location ?r - robot)
        :precondition (and
            ; handling position that must be the same for object involved
            (be_at_robot ?l ?r )
            (be_at_box ?b ?l)
            ; carrier must be assigned to robot 
            (assigned_robot_carrier  ?cr ?r)
            ; box must be assigned to carrier
            (assigned_carrier_box  ?b ?cr)         
            ; parte carrier
            (carrier_capacity_0 ?cr )
        )
        :effect (and
            ; carrier has no more box assigned 
            (not
                (assigned_carrier_box  ?b ?cr)
            )  
            ; parte carrier
            (not
                (carrier_capacity_0 ?cr)
            ) 
            (carrier_capacity_1 ?cr )

        )
    )
    
    ; empty box
    (:action empty
        :parameters ( ?b - box ?c - content ?l - generic_location  ?p - person ?r - robot)
        :precondition (and
            ; robot, box, content, person at same location
            (be_at_robot ?l ?r )
            (be_at_box ?b ?l)
            (be_at_content ?c ?l)
            (be_at_person ?l ?p )
            ; box contains content
            (assigned_box_content ?b ?c)
            ; box should not be contained in carrier (but instead delivered)
            (forall (?cr - carrier)
            	(not
            		(assigned_carrier_box ?b ?cr )
            	)
            )

         )
        :effect (and
            ; box is no more related to content 
            (not
                (assigned_box_content ?b ?c)
            )

            ; content is now assigned to person 
            (assigned_person_content ?c ?p )
       
        )
    )
    
    ; ACTION SECTION - handling movement 
    
    (:action move_cc_4
        :parameters (?cr - carrier ?l1 - generic_location ?l2 - generic_location ?r - robot)
        :precondition (and
            ; check if not same locations
	    (not 
	        (= ?l1 ?l2)
	    )
            ; robot must be located at start 
            (be_at_robot ?l1 ?r )
            ; robot must be empty
            (carrier_capacity_4 ?cr)
        )
        :effect (and
            ;robot no more at start...
            (not
                (be_at_robot ?l1 ?r )
            )
            ; but it is at the end 
            (be_at_robot ?l2 ?r )
        )     
    )

    ; move when only single box carried 
    (:action move_cc_3_wc
        :parameters (?b - box ?c - content ?cr - carrier  ?l1 - generic_location ?l2 - location ?r - robot)
        :precondition (and
            ; check if not same locations
	    (not 
	        (= ?l1 ?l2)
	    )
            ; robot, box and content must be located at start 
            (be_at_robot ?l1 ?r )
            (be_at_box ?b ?l1)
            (be_at_content ?c ?l1)
            (assigned_carrier_box  ?b ?cr)
            (assigned_box_content ?b ?c)
            (carrier_capacity_3 ?cr)
        )
        :effect (and
            ; update robot position 
            (not
                (be_at_robot ?l1 ?r )
            )
            (be_at_robot ?l2 ?r )
            ; update content position
            (not
                (be_at_content ?c ?l1)
            )
            (be_at_content ?c ?l2)
            ; update box position  
            (not
                (be_at_box ?b ?l1)
            )
            (be_at_box ?b ?l2)
        )         
    )
    (:action move_cc_3_noc
        :parameters (?b - box  ?cr - carrier  ?l1 - generic_location ?l2 - generic_location ?r - robot)
        :precondition (and
            ; check if not same locations
	    (not 
	        (= ?l1 ?l2)
	    )
            ;; robot, box and content must be located at start 
            (be_at_robot ?l1 ?r )
            (be_at_box ?b ?l1)
            (assigned_carrier_box  ?b ?cr)
            (carrier_capacity_3 ?cr)
            (forall (?c - content)
            	(not
            	    (assigned_box_content ?b ?c)
            	)
            )
        )
        :effect (and
            ; update robot position 
            (not
                (be_at_robot ?l1 ?r )
            )
            (be_at_robot ?l2 ?r )
            ; update box position  
            (not
                (be_at_box ?b ?l1)
            )
            (be_at_box ?b ?l2)
        )         
    )
    
    ; move when two box carried 
    (:action move_cc_2_wcwc
        :parameters (?b1 ?b2 - box ?c1 ?c2 - content ?cr - carrier ?l1 - generic_location ?l2 - location ?r - robot)
        :precondition (and
            ; check if not same locations
	    (not 
	        (= ?l1 ?l2)
	    )
	    ; boxes have not be the same (consequently also content are not the same)
	    (not 
		(= ?b1 ?b2)
	    )	   
            ; robot, box and content must be located at start 
            (be_at_robot ?l1 ?r )
            ; boxe position
            (be_at_box ?b1 ?l1)
            (be_at_box ?b2 ?l1)
            ;contents position
            (be_at_content ?c1 ?l1)
            (be_at_content ?c2 ?l1)
            ;assignment carrier boxes 
            (assigned_carrier_box ?b1 ?cr )
            (assigned_carrier_box ?b2 ?cr )
            ;assignment box contents 
            (assigned_box_content ?b1 ?c1)
            (assigned_box_content ?b2 ?c2)
            (carrier_capacity_2 ?cr)
        )
        :effect (and
            ; update robot position 
            (not
                (be_at_robot ?l1 ?r )
            )
            (be_at_robot ?l2 ?r )
            ; update contents position
            (not
                (be_at_content ?c1 ?l1)
            )
            (be_at_content ?c1 ?l2)
            (not
                (be_at_content ?c2 ?l1)
            )
            (be_at_content ?c2 ?l2)
            ; update boxes position  
            (not
                (be_at_box ?b1 ?l1)
            )
            (be_at_box ?b1 ?l2)
            (not
                (be_at_box ?b2 ?l1)
            )
            (be_at_box ?b2 ?l2)
        )         
    )
    ; move when two box carried 
    (:action move_cc_2_nocnoc
        :parameters (?b1 ?b2 - box  ?cr - carrier ?l1 - generic_location ?l2 - generic_location ?r - robot)
        :precondition (and
            ; check if not same locations
	    (not 
	        (= ?l1 ?l2)
	    )
	    ; boxes have not be the same (consequently also content are not the same)
	    (not 
		(= ?b1 ?b2)
	    )	   
            ; robot, box and content must be located at start 
            (be_at_robot ?l1 ?r )
            ; boxe position
            (be_at_box ?b1 ?l1)
            (be_at_box ?b2 ?l1)
            (forall (?c - content)
            	(not
            	    (assigned_box_content ?b1 ?c)
            	)
            )
            (forall (?c - content)
            	(not
            	    (assigned_box_content ?b2 ?c)
            	)
            )
            ;assignment carrier boxes 
            (assigned_carrier_box ?b1 ?cr )
            (assigned_carrier_box ?b2 ?cr )
            (carrier_capacity_2 ?cr)
        )
        :effect (and
            ; update robot position 
            (not
                (be_at_robot ?l1 ?r )
            )
            (be_at_robot ?l2 ?r )
            ; update boxes position  
            (not
                (be_at_box ?b1 ?l1)
            )
            (be_at_box ?b1 ?l2)
            (not
                (be_at_box ?b2 ?l1)
            )
            (be_at_box ?b2 ?l2)
        )         
    )
    ; move when two box carried 
    (:action move_cc_2_wcnoc
        :parameters (?b1 ?b2 - box ?c1 - content ?cr - carrier ?l1 - generic_location ?l2 - location ?r - robot)
        :precondition (and
            ; check if not same locations
	    (not 
	        (= ?l1 ?l2)
	    )
	    ; boxes have not be the same (consequently also content are not the same)
	    (not 
		(= ?b1 ?b2)
	    )	   
            ; robot, box and content must be located at start 
            (be_at_robot ?l1 ?r )
            ; boxe position
            (be_at_box ?b1 ?l1)
            (be_at_box ?b2 ?l1)

            ;assignment box content 
            (assigned_box_content ?b1 ?c1 )
            (forall (?c - content)
            	(not
            	    (assigned_box_content ?b2 ?c)
            	)
            )
            ;assignment carrier boxes 
            (assigned_carrier_box ?b1 ?cr )
            (assigned_carrier_box ?b2 ?cr )
            (carrier_capacity_2 ?cr)
        )
        :effect (and
            ; update robot position 
            (not
                (be_at_robot ?l1 ?r )
            )
            (be_at_robot ?l2 ?r )
            ; update contents position
            (not
                (be_at_content ?c1 ?l1)
            )
            (be_at_content ?c1 ?l2)
            ; update boxes position  
            (not
                (be_at_box ?b1 ?l1)
            )
            (be_at_box ?b1 ?l2)
            (not
                (be_at_box ?b2 ?l1)
            )
            (be_at_box ?b2 ?l2)
        )         
    )
    
    
    ; move when three box carried 
    (:action move_cc_1_wcwcwc
        :parameters (?b1 ?b2 ?b3 - box ?c1 ?c2 ?c3 - content ?cr - carrier  ?l1 - generic_location ?l2 - location ?r - robot)
        :precondition (and
            ; check if not same locations
	    (not 
	        (= ?l1 ?l2)
	    )
	    ; boxes have not be the same (consequently also content are not the same)
	    (not 
		(= ?b1 ?b2)
	    )
	    (not 
		(= ?b1 ?b3)
	    )
	    (not 
		(= ?b2 ?b3)
	    )
            ; robot, box and content must be located at start 
            (be_at_robot ?l1 ?r )
            ; boxe position
            (be_at_box ?b1 ?l1)
            (be_at_box ?b2 ?l1)
            (be_at_box ?b3 ?l1)
            ;contents position
            (be_at_content ?c1 ?l1)
            (be_at_content ?c2 ?l1)
            (be_at_content ?c3 ?l1)
            ;assignment carrier boxes 
            (assigned_carrier_box  ?b1 ?cr)
            (assigned_carrier_box ?b2 ?cr)
            (assigned_carrier_box ?b3 ?cr)
            ;assignment box contents 
            (assigned_box_content ?b1 ?c1)
            (assigned_box_content ?b2 ?c2)
            (assigned_box_content ?b3 ?c3)
            (carrier_capacity_1 ?cr)
        )
        :effect (and
            ; update robot position 
            (not
                (be_at_robot  ?l1 ?r)
            )
            (be_at_robot ?l2 ?r )
            ; update contents position
            (not
                (be_at_content ?c1 ?l1)
            )
            (be_at_content ?c1 ?l2)
            (not
                (be_at_content ?c2 ?l1)
            )
            (be_at_content ?c2 ?l2)
            (not
                (be_at_content ?c3 ?l1)
            )
            (be_at_content ?c3 ?l2)
            ; update boxes position  
            (not
                (be_at_box ?b1 ?l1)
            )
            (be_at_box ?b1 ?l2)
            (not
                (be_at_box ?b2 ?l1)
            )
            (be_at_box ?b2 ?l2)
            (not
                (be_at_box ?b3 ?l1)
            )
            (be_at_box ?b3 ?l2)
        )         
    )
    (:action move_cc_1_nocnocnoc
        :parameters (?b1 ?b2 ?b3 - box ?c1 ?c2 ?c3 - content ?cr - carrier  ?l1 - generic_location ?l2 - generic_location ?r - robot)
        :precondition (and
            ; check if not same locations
	    (not 
	        (= ?l1 ?l2)
	    )
	    ; boxes have not be the same (consequently also content are not the same)
	    (not 
		(= ?b1 ?b2)
	    )
	    (not 
		(= ?b1 ?b3)
	    )
	    (not 
		(= ?b2 ?b3)
	    )
            ; robot, box and content must be located at start 
            (be_at_robot ?l1 ?r )
            ; boxe position
            (be_at_box ?b1 ?l1)
            (be_at_box ?b2 ?l1)
            (be_at_box ?b3 ?l1)
            (forall (?c - content)
            	(not
            	    (assigned_box_content ?b1 ?c)
            	)
            )
            (forall (?c - content)
            	(not
            	    (assigned_box_content ?b2 ?c)
            	)
            )
            (forall (?c - content)
            	(not
            	    (assigned_box_content ?b3 ?c)
            	)
            )
            ;assignment carrier boxes 
            (assigned_carrier_box  ?b1 ?cr)
            (assigned_carrier_box ?b2 ?cr)
            (assigned_carrier_box ?b3 ?cr)
            (carrier_capacity_1 ?cr)
        )
        :effect (and
            ; update robot position 
            (not
                (be_at_robot  ?l1 ?r)
            )
            (be_at_robot ?l2 ?r )           
            ; update boxes position  
            (not
                (be_at_box ?b1 ?l1)
            )
            (be_at_box ?b1 ?l2)
            (not
                (be_at_box ?b2 ?l1)
            )
            (be_at_box ?b2 ?l2)
            (not
                (be_at_box ?b3 ?l1)
            )
            (be_at_box ?b3 ?l2)
        )         
    )
    (:action move_cc_1_wcnocnoc
        :parameters (?b1 ?b2 ?b3 - box ?c1  - content ?cr - carrier  ?l1 - generic_location ?l2 - location ?r - robot)
        :precondition (and
            ; check if not same locations
	    (not 
	        (= ?l1 ?l2)
	    )
	    ; boxes have not be the same (consequently also content are not the same)
	    (not 
		(= ?b1 ?b2)
	    )
	    (not 
		(= ?b1 ?b3)
	    )
	    (not 
		(= ?b2 ?b3)
	    )
            ; robot, box and content must be located at start 
            (be_at_robot ?l1 ?r )
            ; boxe position
            (be_at_box ?b1 ?l1)
            (be_at_box ?b2 ?l1)
            (be_at_box ?b3 ?l1)
            ;contents position
            (be_at_content ?c1 ?l1)
            (forall (?c - content)
            	(not
            	    (assigned_box_content ?b2 ?c)
            	)
            )
            (forall (?c - content)
            	(not
            	    (assigned_box_content ?b3 ?c)
            	)
            )
            ;assignment carrier boxes 
            (assigned_carrier_box  ?b1 ?cr)
            (assigned_carrier_box ?b2 ?cr)
            (assigned_carrier_box ?b3 ?cr)
            ;assignment box contents 
            (assigned_box_content ?b1 ?c1)
            (carrier_capacity_1 ?cr)
        )
        :effect (and
            ; update robot position 
            (not
                (be_at_robot  ?l1 ?r)
            )
            (be_at_robot ?l2 ?r )
            ; update contents position
            (not
                (be_at_content ?c1 ?l1)
            )
            (be_at_content ?c1 ?l2)            
            ; update boxes position  
            (not
                (be_at_box ?b1 ?l1)
            )
            (be_at_box ?b1 ?l2)
            (not
                (be_at_box ?b2 ?l1)
            )
            (be_at_box ?b2 ?l2)
            (not
                (be_at_box ?b3 ?l1)
            )
            (be_at_box ?b3 ?l2)
        )         
    )
    ; move when three box carried 
    (:action move_cc_1_wcwcnoc
        :parameters (?b1 ?b2 ?b3 - box ?c1 ?c2  - content ?cr - carrier  ?l1 - generic_location ?l2 - location ?r - robot)
        :precondition (and
            ; check if not same locations
	    (not 
	        (= ?l1 ?l2)
	    )
	    ; boxes have not be the same (consequently also content are not the same)
	    (not 
		(= ?b1 ?b2)
	    )
	    (not 
		(= ?b1 ?b3)
	    )
	    (not 
		(= ?b2 ?b3)
	    )
            ; robot, box and content must be located at start 
            (be_at_robot ?l1 ?r )
            ; boxe position
            (be_at_box ?b1 ?l1)
            (be_at_box ?b2 ?l1)
            (be_at_box ?b3 ?l1)
            ;contents position
            (be_at_content ?c1 ?l1)
            (be_at_content ?c2 ?l1)
            (forall (?c - content)
            	(not
            	    (assigned_box_content ?b3 ?c)
            	)
            )
            ;assignment carrier boxes 
            (assigned_carrier_box  ?b1 ?cr)
            (assigned_carrier_box ?b2 ?cr)
            (assigned_carrier_box ?b3 ?cr)
            ;assignment box contents 
            (assigned_box_content ?b1 ?c1)
            (assigned_box_content ?b2 ?c2)
            (carrier_capacity_1 ?cr)
        )
        :effect (and
            ; update robot position 
            (not
                (be_at_robot  ?l1 ?r)
            )
            (be_at_robot ?l2 ?r )
            ; update contents position
            (not
                (be_at_content ?c1 ?l1)
            )
            (be_at_content ?c1 ?l2)
            (not
                (be_at_content ?c2 ?l1)
            )
            (be_at_content ?c2 ?l2)
            
            ; update boxes position  
            (not
                (be_at_box ?b1 ?l1)
            )
            (be_at_box ?b1 ?l2)
            (not
                (be_at_box ?b2 ?l1)
            )
            (be_at_box ?b2 ?l2)
            (not
                (be_at_box ?b3 ?l1)
            )
            (be_at_box ?b3 ?l2)
        )         
    )
    
    ; move when four box carried 
    ; here is possible to move to generic location as result of movement (return to depot)
    (:action move_cc_0_wcwcwcwc
        :parameters (?b1 ?b2 ?b3 ?b4 - box ?c1 ?c2 ?c3 ?c4 - content  ?cr - carrier ?l1 - generic_location ?l2 - generic_location ?r - robot)
        :precondition (and
            ; check if not same locations
	    (not 
	        (= ?l1 ?l2)
	    )
	    ; boxes have not be the same (consequently also content are not the same)
	    (not 
		(= ?b1 ?b2)
	    )
	    (not 
		(= ?b1 ?b3)
	    )
	    (not 
		(= ?b2 ?b3)
	    )
	    (not 
		(= ?b2 ?b4)
	    )
	    (not 
		(= ?b1 ?b4)
	    )
	    (not 
		(= ?b3 ?b4)
	    )
            ; robot, box and content must be located at start 
            (be_at_robot ?l1 ?r )
            ; boxe position
            (be_at_box ?b1 ?l1)
            (be_at_box ?b2 ?l1)
            (be_at_box ?b3 ?l1)
            (be_at_box ?b4 ?l1)
            ;contents position
            (be_at_content ?c1 ?l1)
            (be_at_content ?c2 ?l1)
            (be_at_content ?c3 ?l1)
            (be_at_content ?c4 ?l1)
            ;assignment carrier boxes 
            (assigned_carrier_box ?b1 ?cr )
            (assigned_carrier_box ?b2 ?cr )
            (assigned_carrier_box ?b3 ?cr )
            (assigned_carrier_box ?b4 ?cr )
            ;assignment box contents 
            (assigned_box_content ?b1 ?c1)
            (assigned_box_content ?b2 ?c2)
            (assigned_box_content ?b3 ?c3)
            (assigned_box_content ?b4 ?c4)
            (carrier_capacity_0 ?cr)
        )
        :effect (and
            ; update robot position 
            (not
                (be_at_robot ?l1 ?r )
            )
            (be_at_robot ?l2 ?r )
            ; update contents position
            (not
                (be_at_content ?c1 ?l1)
            )
            (be_at_content ?c1 ?l2)
            (not
                (be_at_content ?c2 ?l1)
            )
            (be_at_content ?c2 ?l2)
            (not
                (be_at_content ?c3 ?l1)
            )
            (be_at_content ?c3 ?l2)
            (not
                (be_at_content ?c4 ?l1)
            )
            (be_at_content ?c4 ?l2)
            ; update boxes position  
            (not
                (be_at_box ?b1 ?l1)
            )
            (be_at_box ?b1 ?l2)
            (not
                (be_at_box ?b2 ?l1)
            )
            (be_at_box ?b2 ?l2)
            (not
                (be_at_box ?b3 ?l1)
            )
            (be_at_box ?b3 ?l2)
            (not
                (be_at_box ?b4 ?l1)
            )
            (be_at_box ?b4 ?l2)
        )         
    )
    (:action move_cc_0_nocnocnocnoc
        :parameters (?b1 ?b2 ?b3 ?b4 - box  ?cr - carrier ?l1 - generic_location ?l2 - generic_location ?r - robot )
        :precondition (and
            ; check if not same locations
	    (not 
	        (= ?l1 ?l2)
	    )
	    ; boxes have not be the same (consequently also content are not the same)
	    (not 
		(= ?b1 ?b2)
	    )
	    (not 
		(= ?b1 ?b3)
	    )
	    (not 
		(= ?b2 ?b3)
	    )
	    (not 
		(= ?b2 ?b4)
	    )
	    (not 
		(= ?b1 ?b4)
	    )
	    (not 
		(= ?b3 ?b4)
	    )
            ; robot, box and content must be located at start 
            (be_at_robot  ?l1 ?r)
            ; boxe position
            (be_at_box ?b1 ?l1)
            (be_at_box ?b2 ?l1)
            (be_at_box ?b4 ?l1)
            (be_at_box ?b3 ?l1)       
            (forall (?c - content)
            	(not
            	    (assigned_box_content ?b1 ?c)
            	)
            )
            (forall (?c - content)
            	(not
            	    (assigned_box_content ?b2 ?c)
            	)
            )
            (forall (?c - content)
            	(not
            	    (assigned_box_content ?b3 ?c)
            	)
            )
            (forall (?c - content)
            	(not
            	    (assigned_box_content ?b4 ?c)
            	)
            )
            ;assignment carrier boxes 
            (assigned_carrier_box ?b1 ?cr )
            (assigned_carrier_box ?b2 ?cr )
            (assigned_carrier_box ?b3 ?cr )
            (assigned_carrier_box ?b4 ?cr )
            (carrier_capacity_0 ?cr)
        )
        :effect (and
            ; update robot position 
            (not
                (be_at_robot ?l1 ?r )
            )
            (be_at_robot ?l2 ?r )
           
            ; update boxes position  
            (not
                (be_at_box ?b1 ?l1)
            )
            (be_at_box ?b1 ?l2)
            (not
                (be_at_box ?b2 ?l1)
            )
            (be_at_box ?b2 ?l2)
            (not
                (be_at_box ?b3 ?l1)
            )
            (be_at_box ?b3 ?l2)
            (not
                (be_at_box ?b4 ?l1)
            )
            (be_at_box ?b4 ?l2)
        )         
    )    
 
    (:action move_cc_0_wcnocnocnoc
        :parameters (?b1 ?b2 ?b3 ?b4 - box ?c1  - content  ?cr - carrier ?l1 - generic_location ?l2 - location ?r - robot)
        :precondition (and
            ; check if not same locations
	    (not 
	        (= ?l1 ?l2)
	    )
	    ; boxes have not be the same (consequently also content are not the same)
	    (not 
		(= ?b1 ?b2)
	    )
	    (not 
		(= ?b1 ?b3)
	    )
	    (not 
		(= ?b2 ?b3)
	    )
	    (not 
		(= ?b2 ?b4)
	    )
	    (not 
		(= ?b1 ?b4)
	    )
	    (not 
		(= ?b3 ?b4)
	    )
            ; robot, box and content must be located at start 
            (be_at_robot ?l1  ?r )
            ; boxe position
            (be_at_box ?b1 ?l1)
            (be_at_box ?b2 ?l1)
            (be_at_box ?b4 ?l1)
            (be_at_box ?b3 ?l1)
            ;contents position
            (be_at_content ?c1 ?l1)
            (forall (?c - content)
            	(not
            	    (assigned_box_content ?b2 ?c)
            	)
            )
            (forall (?c - content)
            	(not
            	    (assigned_box_content ?b3 ?c)
            	)
            )
            (forall (?c - content)
            	(not
            	    (assigned_box_content ?b4 ?c)
            	)
            )
            ;assignment carrier boxes 
            (assigned_carrier_box ?b1 ?cr )
            (assigned_carrier_box ?b2 ?cr )
            (assigned_carrier_box ?b3 ?cr )
            (assigned_carrier_box ?b4 ?cr )
            ;assignment box contents 
            (assigned_box_content ?b1 ?c1)
            (carrier_capacity_0 ?cr)
        )
        :effect (and
            ; update robot position 
            (not
                (be_at_robot ?l1 ?r )
            )
            (be_at_robot ?l2 ?r )
            ; update contents position
            (not
                (be_at_content ?c1 ?l1)
            )
            (be_at_content ?c1 ?l2)
            
            ; update boxes position  
            (not
                (be_at_box ?b1 ?l1)
            )
            (be_at_box ?b1 ?l2)
            (not
                (be_at_box ?b2 ?l1)
            )
            (be_at_box ?b2 ?l2)
            (not
                (be_at_box ?b3 ?l1)
            )
            (be_at_box ?b3 ?l2)
            (not
                (be_at_box ?b4 ?l1)
            )
            (be_at_box ?b4 ?l2)
        )         
    ) 
    (:action move_cc_0_wcwcnocnoc
        :parameters (?b1 ?b2 ?b3 ?b4 - box ?c1 ?c2  - content  ?cr - carrier ?l1 - generic_location ?l2 - location ?r - robot)
        :precondition (and
            ; check if not same locations
	    (not 
	        (= ?l1 ?l2)
	    )
	    ; boxes have not be the same (consequently also content are not the same)
	    (not 
		(= ?b1 ?b2)
	    )
	    (not 
		(= ?b1 ?b3)
	    )
	    (not 
		(= ?b2 ?b3)
	    )
	    (not 
		(= ?b2 ?b4)
	    )
	    (not 
		(= ?b1 ?b4)
	    )
	    (not 
		(= ?b3 ?b4)
	    )
            ; robot, box and content must be located at start 
            (be_at_robot  ?l1 ?r)
            ; boxe position
            (be_at_box ?b1 ?l1)
            (be_at_box ?b2 ?l1)
            (be_at_box ?b4 ?l1)
            (be_at_box ?b3 ?l1)
            ;contents position
            (be_at_content ?c1 ?l1)
            (be_at_content ?c2 ?l1)
	    (forall (?c - content)
            	(not
            	    (assigned_box_content ?b3 ?c)
            	)
            )
            (forall (?c - content)
            	(not
            	    (assigned_box_content ?b4 ?c)
            	)
            )
            ;assignment carrier boxes 
            (assigned_carrier_box ?b1 ?cr )
            (assigned_carrier_box ?b2 ?cr )
            (assigned_carrier_box ?b3 ?cr )
            (assigned_carrier_box ?b4 ?cr )
            ;assignment box contents 
            (assigned_box_content ?b1 ?c1)
            (assigned_box_content ?b2 ?c2)
            (carrier_capacity_0 ?cr)
        )
        :effect (and
            ; update robot position 
            (not
                (be_at_robot ?l1 ?r )
            )
            (be_at_robot ?l2 ?r )
            ; update contents position
            (not
                (be_at_content ?c1 ?l1)
            )
            (be_at_content ?c1 ?l2)
            (not
                (be_at_content ?c2 ?l1)
            )
            (be_at_content ?c2 ?l2)
            
            ; update boxes position  
            (not
                (be_at_box ?b1 ?l1)
            )
            (be_at_box ?b1 ?l2)
            (not
                (be_at_box ?b2 ?l1)
            )
            (be_at_box ?b2 ?l2)
            (not
                (be_at_box ?b3 ?l1)
            )
            (be_at_box ?b3 ?l2)
            (not
                (be_at_box ?b4 ?l1)
            )
            (be_at_box ?b4 ?l2)
        )         
    )
    (:action move_cc_0_wcwcwcnoc
        :parameters (?b1 ?b2 ?b3 ?b4 - box ?c1 ?c2 ?c3 - content  ?cr - carrier ?l1 - generic_location ?l2 - location ?r - robot)
        :precondition (and
            ; check if not same locations
	    (not 
	        (= ?l1 ?l2)
	    )
	    ; boxes have not be the same (consequently also content are not the same)
	    (not 
		(= ?b1 ?b2)
	    )
	    (not 
		(= ?b1 ?b3)
	    )
	    (not 
		(= ?b2 ?b3)
	    )
	    (not 
		(= ?b2 ?b4)
	    )
	    (not 
		(= ?b1 ?b4)
	    )
	    (not 
		(= ?b3 ?b4)
	    )
            ; robot, box and content must be located at start 
            (be_at_robot  ?l1 ?r)
            ; boxe position
            (be_at_box ?b1 ?l1)
            (be_at_box ?b2 ?l1)
            (be_at_box ?b4 ?l1)
            (be_at_box ?b3 ?l1)
            ;contents position
            (be_at_content ?c1 ?l1)
            (be_at_content ?c2 ?l1)
            (be_at_content ?c3 ?l1)
            (forall (?c - content)
            	(not
            	    (assigned_box_content ?b4 ?c)
            	)
            )
            ;assignment carrier boxes 
            (assigned_carrier_box ?b1 ?cr )
            (assigned_carrier_box ?b2 ?cr )
            (assigned_carrier_box ?b3 ?cr )
            (assigned_carrier_box ?b4 ?cr )
            ;assignment box contents 
            (assigned_box_content ?b1 ?c1)
            (assigned_box_content ?b2 ?c2)
            (assigned_box_content ?b3 ?c3)
            (carrier_capacity_0 ?cr)
        )
        :effect (and
            ; update robot position 
            (not
                (be_at_robot ?l1 ?r )
            )
            (be_at_robot ?l2 ?r )
            ; update contents position
            (not
                (be_at_content ?c1 ?l1)
            )
            (be_at_content ?c1 ?l2)
            (not
                (be_at_content ?c2 ?l1)
            )
            (be_at_content ?c2 ?l2)
            (not
                (be_at_content ?c3 ?l1)
            )
            (be_at_content ?c3 ?l2)
            ; update boxes position  
            (not
                (be_at_box ?b1 ?l1)
            )
            (be_at_box ?b1 ?l2)
            (not
                (be_at_box ?b2 ?l1)
            )
            (be_at_box ?b2 ?l2)
            (not
                (be_at_box ?b3 ?l1)
            )
            (be_at_box ?b3 ?l2)
            (not
                (be_at_box ?b4 ?l1)
            )
            (be_at_box ?b4 ?l2)
        )         
    )
 
    
  

) 
