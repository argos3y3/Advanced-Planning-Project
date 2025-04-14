; AUTHOR: Dimitri Vinci
; BRIEF DESCRIPTION:
; Domain for ex1 of APTP exam project
; PLANNING VERSION: Classical planning, PDDL 2.1/2.2
; REQUIRE: strips + typing + equality + adl + negative precondition

(define 

    ; DOMAIN AND REQUIREMENTS SECTION
    
    (domain ex1_adl_plus_neg)
    
    (:requirements 
        :strips :typing :equality 
        :negative-preconditions
        :conditional-effects :existential-preconditions :disjunctive-preconditions :universal-preconditions :adl
    )
    
    ; TYPES AND PREDICATES SECTION
    
    (:types 
        location person box robot content - object  
        medicine tool food - content ;; subclassed content
    )

    (:predicates
        ; position
        (be_at_person ?l - location ?p - person )  ;; true if person is in a given location
        (be_at_box ?b - box ?l - location)  ;; true if box is in a given location
        (be_at_content ?c - content ?l - location)  ;; true if content is in a given location
        (be_at_robot ?l - location ?r - robot )  ;; true if content is in a given location
        ; handle relation between object
        ; box
        (assigned_box_content ?b - box ?c - content)  ;; true if a box contain a content
        ; person
        (assigned_person_content  ?c - content ?p - person)  ;; true if a person has assigned a content
        ; robot
        (assigned_robot_box ?b - box ?r - robot )  ;; true if robot is carrying an object

    )
    
    ; ACTION SECTION
    
    ; ACTION SECTION - handling boxes 
    
    ; fill box with content
    (:action fill_box
	:parameters (?b - box ?c - content ?l - location ?r - robot)
        :precondition (and
            ; robot, box and content in same location
            (be_at_robot ?l ?r)
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
            ; no robot should have this content assigned
            (forall (?r1 - robot)
                (not
                    (assigned_robot_box ?b ?r1)
                )
            )          
        )
        :effect (and
            ; box is now assigned 
            (assigned_box_content ?b ?c)
        )     
    )     
    
    ; pick up a box
    (:action pick_up
        :parameters (?b - box ?l - location ?r - robot)
        :precondition (and
            ; robot, box and content in same location
            (be_at_robot ?l ?r)
            (be_at_box ?b ?l)
            ; the box should not be carried by this robot
            (forall (?b1 - box)
                (not
                    (assigned_robot_box  ?b1 ?r)
                )
            )
            ; no robot should have this content assigned
            (forall (?r1 - robot)
                (not
                    (assigned_robot_box ?b ?r1)
                )
            )  
        )
        :effect (and
            ; now robot has a box assigned 
            (assigned_robot_box  ?b ?r)
        )     
    )
    
    ; drop a box
    (:action drop
        :parameters (?r - robot ?b - box  ?l - location)
        :precondition (and
                ; handling position that must be the same for object involved
                (be_at_robot ?l ?r)
                (be_at_box ?b ?l)
                ; box must be assigned to robot 
                (assigned_robot_box  ?b ?r)
            )
        :effect (and
            ; box no more assigned to box 
            (not
                (assigned_robot_box  ?b ?r)
            )  
        )
    )
    
    ; empty a box assigning it to person
    (:action empty
        :parameters (?b - box ?c - content ?l - location  ?p - person ?r - robot)
        :precondition (and
            ; robot, box, content, person at same location
            (be_at_robot ?l ?r )
            (be_at_box ?b ?l)
            (be_at_content ?c ?l)
            (be_at_person ?l ?p )
            ; box contains content
            (assigned_box_content ?b ?c)
            ; no robot should have this content assigned
            (forall (?r1 - robot)
                (not
                    (assigned_robot_box ?b ?r1)
                )
            )   
         )
        :effect (and
            ; box is no more related to content 
            (not
                (assigned_box_content ?b ?c)
            )
            ; content is now assigned to person 
            (assigned_person_content ?c ?p)            
        )
    )
    
    ; ACTION SECTION - handling movement 
    
    ; move without box carried
    (:action move_empty
        :parameters (?l1 ?l2 - location ?r - robot)
        :precondition (and
            ; check no same location
            (not
                (= ?l1 ?l2)
            )
            ; robot must be located at start 
            (be_at_robot ?l1 ?r)
            (forall (?b - box) 
               (not
                    (assigned_robot_box  ?b ?r)
                )
            ) 
        )
        :effect (and
            ;robot no more at start...
            (not
                (be_at_robot ?l1 ?r)
            )
            ; but it is at the end 
            (be_at_robot ?l2 ?r)
        )     
    )

    ; move with box carried
    ; move with box carried and content inside
    (:action move_full_wc
        :parameters (?b - box ?c - content ?l1 ?l2 - location ?r - robot)
        :precondition (and
            ; check no same location
            (not
                (= ?l1 ?l2)
            )
            ; robot, box and content must be located at start 
            (be_at_robot  ?l1 ?r)
            (be_at_box ?b ?l1)
            (be_at_content ?c ?l1)
            (assigned_robot_box  ?b ?r)
            (assigned_box_content ?b ?c)
        )
        :effect (and
            ; update robot position 
            (not
                (be_at_robot  ?l1 ?r)
            )
            (be_at_robot ?l2 ?r)
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
    ; move with box carried and no content inside
    (:action move_full_noc
        :parameters (?b - box ?l1 ?l2 - location ?r - robot)
        :precondition (and
            ; check no same location
            (not
                (= ?l1 ?l2)
            )
            ; robot, box and content must be located at start 
            (be_at_robot  ?l1 ?r)
            (be_at_box ?b ?l1)
            (assigned_robot_box  ?b ?r)
            (forall (?c - content)
            	(not
            	    (assigned_box_content ?b ?c)
            	)
            )
        )
        :effect (and
            ; update robot position 
            (not
                (be_at_robot  ?l1 ?r)
            )
            (be_at_robot  ?l2 ?r)
           
            ; update box position  
            (not
                (be_at_box ?b ?l1)
            )
            (be_at_box ?b ?l2)
        )         
    )

)
