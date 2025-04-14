; AUTHOR: Dimitri Vinci
; BRIEF DESCRIPTION:
; Domain for ex1 of APTP exam project
; PLANNING VERSION: Classical planning, PDDL 2.1/2.2
; REQUIRE: strips + typing + equality + negative precondition

(define 
    
    ; DOMAIN AND REQUIREMENTS SECTION
        
    (domain ex1_strip_plus_neg)

    (:requirements :strips :typing :equality :negative-preconditions)  
    
    ; TYPES AND PREDICATES SECTION
    
    (:types 
        location person box robot content - object  
        medicine tool food - content  ;; subclassed content
    )
 
    (:predicates
        ; position
        (be_at_person ?l - location ?p - person )  ;; true if person is in a given location
        (be_at_box ?b - box ?l - location)  ;; true if box is in a given location
        (be_at_content ?c - content ?l - location)  ;; true if content is in a given location
        (be_at_robot ?l - location ?r - robot )  ;; true if content is in a given location
        ; handle relation between object
        ; box
        (empty_box ?b - box)  ;; true if box not partecipate in any assigned_box_content predicate 
        (assigned_box_content ?b - box ?c - content)  ;; true if a box contain a content
        (is_assigned_box ?b - box) ;; to check if box is not assigned to an agent
        ; person
        (assigned_person_content ?c - content ?p - person )  ;; true if a person has assigned a content 
        ; robot
        (empty_robot ?r - robot)  ;; true if robot not partecipate in any assigned_robot_box predicate 
        (assigned_robot_box ?b - box ?r - robot )  ;; true if robot is carrying an object
        ; content
        (is_assigned ?c - content)  ;; true if a content partecipate in at least one assigned assigned_box_content predicate  
    )
    
    ; ACTION SECTION
    
    ; ACTION SECTION - handling boxes 
    
    ; fill a box with a content
    (:action fill_box
	:parameters (?b - box ?c - content ?l - location ?r - robot)
        :precondition (and
            ; robot, box and content in same location
            (be_at_robot ?l ?r)
            (be_at_box ?b ?l)
            (be_at_content ?c ?l)
            ; box must be empty 
            (empty_box ?b)
            ; robot cannot steal content from box to other box 
            (not
                (is_assigned ?c)
            )
            ; robot cannot act on content handled by other bot
            (not (is_assigned_box ?b)) 
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
    
    ; pick up a box 
    (:action pick_up
        :parameters (?b - box ?l - location ?r - robot)
        :precondition (and
            ; robot, box and content in same location
            (be_at_robot ?l ?r)
            (be_at_box ?b ?l)
            ; robot must not carry other box 
            (empty_robot ?r)
            ; robot cannot act on content handled by other bot
            (not (is_assigned_box ?b))           
        )
        :effect (and
            ; robot is now carrying a box 
            (not
               (empty_robot ?r)
            )
            ; now robot has a box assigned 
            (assigned_robot_box ?b ?r )
            (is_assigned_box ?b)
        )     
    )
    
    ; drop a box
    (:action drop
        :parameters ( ?b - box ?l - location  ?r - robot)
        :precondition (and
                ; handling position that must be the same for object involved
                (be_at_robot ?l ?r )
                (be_at_box ?b ?l)
                ; box must be assigned to robot 
                (assigned_robot_box ?b ?r) 
            )
        :effect (and
            ; box no more assigned to box 
            (not
                (assigned_robot_box ?b ?r)
            )  
            (empty_robot ?r)
            (not 
            	(is_assigned_box ?b)
            ) 
        )
    )
    
    ; empty a box assigning its content to person
    (:action empty
        :parameters (?b - box ?c - content ?l - location ?p - person ?r - robot)
        :precondition (and
            ; robot, box, content, person at same location
            (be_at_robot ?l ?r )
            (be_at_box ?b ?l)
            (be_at_content ?c ?l)
            (be_at_person ?l ?p )
            ; box contains content
            (assigned_box_content ?b ?c)
            ; robot cannot act on content handled by other bot
            (not (is_assigned_box ?b)) 
         )
        :effect (and
            ; box is no more related to content 
            (not
                (assigned_box_content ?b ?c)
            )
            ; content is now assigned to person 
            (assigned_person_content ?c ?p)
            (empty_box ?b)
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
            (be_at_robot ?l1 ?r )
            ; robot must be empty
            (empty_robot ?r)
        )
        :effect (and
            ; robot no more at start...
            (not
                (be_at_robot ?l1 ?r)
            )
            ; but it is at the end 
            (be_at_robot ?l2 ?r)            
        )     
    )

    ; move with box carried
    ; move with box carried with content inside
    (:action move_full_wc
        :parameters (?b - box ?c - content ?l1 ?l2 - location ?r - robot)
        :precondition (and
            ; check no same location
            (not
                (= ?l1 ?l2)
            )
            ; robot, box and content must be located at start 
            (be_at_robot ?l1 ?r )
            (be_at_box ?b ?l1)
            (be_at_content ?c ?l1)
            (assigned_robot_box ?b ?r )
            (assigned_box_content ?b ?c)
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
    ; move with box carried without content inside
    (:action move_full_noc
        :parameters ( ?b - box  ?l1 ?l2 - location ?r - robot)
        :precondition (and
            ; check no same location
            (not
                (= ?l1 ?l2)
            )
            ; robot, box and content must be located at start 
            (be_at_robot ?l1 ?r )
            (be_at_box ?b ?l1)
	    (empty_box ?b)
            (assigned_robot_box ?b ?r )        
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


)

