(define (problem ex1_adl_plus_p6)
    (:domain ex1_adl_plus)
    ; OBJECT DEFINITION
    (:objects
       depot - location ;; our initial depot
       location1 - location ;; other location avaiable
       robot1 - robot ;; our agent
       box1 box2 box3 box4 box5 box6 - box ;; three box avaiable
       person1 person2  - person ;; person to be rescued
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
        (be_at_person location1 person2)        
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
        (not_assigned_box_content box1 content2)
        (not_assigned_box_content box1 content3)
        (not_assigned_box_content box1 content4)
        (not_assigned_box_content box1 content5)
        (not_assigned_box_content box1 content6)
        (not_assigned_box_content box2 content1)
        (not_assigned_box_content box2 content2)
        (not_assigned_box_content box2 content3)
        (not_assigned_box_content box2 content4)
        (not_assigned_box_content box2 content5)
        (not_assigned_box_content box2 content6)
        (not_assigned_box_content box3 content1)
        (not_assigned_box_content box3 content2)
        (not_assigned_box_content box3 content3)
        (not_assigned_box_content box3 content4)
        (not_assigned_box_content box3 content5)
        (not_assigned_box_content box3 content6)
        (not_assigned_box_content box4 content1)
        (not_assigned_box_content box4 content2)
        (not_assigned_box_content box4 content3)
        (not_assigned_box_content box4 content4)
        (not_assigned_box_content box4 content5)
        (not_assigned_box_content box4 content6)
        (not_assigned_box_content box5 content1)
        (not_assigned_box_content box5 content2)
        (not_assigned_box_content box5 content3)
        (not_assigned_box_content box5 content4)
        (not_assigned_box_content box5 content5)
        (not_assigned_box_content box5 content6)
        (not_assigned_box_content box6 content1)
        (not_assigned_box_content box6 content2)
        (not_assigned_box_content box6 content3)
        (not_assigned_box_content box6 content4)
        (not_assigned_box_content box6 content5)
        (not_assigned_box_content box6 content6)
        ; no box is assigned to any robot 
        (not_assigned_robot_box box1 robot1)
        (not_assigned_robot_box box2 robot1)
        (not_assigned_robot_box box3 robot1)
        (not_assigned_robot_box box4 robot1)
        (not_assigned_robot_box box5 robot1)
        (not_assigned_robot_box box6 robot1)       
    )
    ; GOAL DEFINITION
    (:goal
        (and
		; deliver food
		(or
		    (assigned_person_content content1 person1)
		    (assigned_person_content content4 person1)
		)
		(or
		    (assigned_person_content content1 person2)
		    (assigned_person_content content4 person2)
		)
		; deliver tool
		(or
		    (assigned_person_content content2 person1)
		    (assigned_person_content content5 person1)
		)
		(or
		    (assigned_person_content content2 person2)
		    (assigned_person_content content5 person2)
		)
		; deliver medicine
		(or
		    (assigned_person_content content3 person1)
		    (assigned_person_content content6 person1)
		)
		(or
		    (assigned_person_content content3 person2)
		    (assigned_person_content content6 person2)
		)
	)  
    )
)
