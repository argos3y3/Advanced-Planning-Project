(define (problem ex1_strip_plus_p4)
    (:domain ex1_strip_plus)
    ; OBJECT DEFINITION
    (:objects
       depot - location ;; our initial depot
       location1 location2 - location ;; other location avaiable
       robot1 - robot ;; our agent
       box1 box2 - box ;; three box avaiable
       person1 person2 - person ;; person to be rescued
       ; content to be delivered
       content1 content4 - food
       content2 content5 - tool
       content3 content6 - medicine
    )
    ; PREDICATE DEFINITION   
    (:init
        ; all box, content, agent at depot initially
        ; box initial position
        (be_at_box box1 depot)
        (be_at_box box2 depot)        
        ; content initial position
        (be_at_content content1 depot)
        (be_at_content content2 depot)
        (be_at_content content3 depot)
        (be_at_content content4 depot)
        (be_at_content content5 depot)
        (be_at_content content6 depot)
        ; robot initial position
        (be_at_robot depot robot1)
        ; people initial position
        (be_at_person location1 person1)
        (be_at_person location2 person2)
        ; note that robot and box must be empty
        (empty_robot robot1)
        (not_empty_robot robot1)
        ; box initial empty
        (empty_box box1)
        (empty_box box2)
        (not_is_assigned_box box1)
        (not_is_assigned_box box2)
        ; is necessary to set true negated version of predicates
        ; no content is assigned to anyone
        (not_assigned_person_content content1 person1)
        (not_assigned_person_content content2 person1)
        (not_assigned_person_content content3 person1)
        (not_assigned_person_content content4 person1)
        (not_assigned_person_content content5 person1)
        (not_assigned_person_content content6 person1)
        (not_assigned_person_content content1 person2)
        (not_assigned_person_content content2 person2)
        (not_assigned_person_content content3 person2)
        (not_assigned_person_content content4 person2)
        (not_assigned_person_content content5 person2)
        (not_assigned_person_content content6 person2)
        ; no box is full
        (not_assigned_box_content box1 content1)
        (not_assigned_box_content box2 content1)
        (not_assigned_box_content box1 content2)
        (not_assigned_box_content box2 content2)
        (not_assigned_box_content box1 content3)
        (not_assigned_box_content box2 content3)
        (not_assigned_box_content box1 content4)
        (not_assigned_box_content box2 content4)
        (not_assigned_box_content box1 content5)
        (not_assigned_box_content box2 content5)
        (not_assigned_box_content box1 content6)
        (not_assigned_box_content box2 content6)
        ; no box is assigned to any robot 
        (not_assigned_robot_box box1 robot1)
        (not_assigned_robot_box box2 robot1)
        ; no content is assigned
        (not_is_assigned content1)
        (not_is_assigned content2)
        (not_is_assigned content3)
        (not_is_assigned content4)
        (not_is_assigned content5)
        (not_is_assigned content6)
    )
    ; GOAL DEFINITION
    (:goal
        (and
		(or
		    (assigned_person_content content1 person1)
		    (assigned_person_content content4 person1)
		)
		(or
		    (assigned_person_content content2 person1)
		    (assigned_person_content content5 person1)
		)
		(or
		    (assigned_person_content content3 person2)
		    (assigned_person_content content6 person2)
		)
        )
    )
)
