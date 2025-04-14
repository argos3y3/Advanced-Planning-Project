(define (problem ex2_adl_plus_p6)
    (:domain ex2_adl_plus)
    ; OBJECT DEFINITION
    (:objects
       depot1 - depot ;; our initial depot1
       location1 - location ;; other location avaiable
       robot1 - robot ;; our agent
       box1 box2 box3 box4 box5 box6 - box ;; three box avaiable
       person1 person2  - person ;; person to be rescued
       ; content to be delivered
       content1 content4 - food
       content2 content5 - tool
       content3 content6 - medicine
       ; carrier
       carrier1 - carrier
    )
    ; PREDICATE DEFINITION    
    (:init
        ; all box, content, agent at depot1 initially
        ; box initial position
        (be_at_box box1 depot1)
        (be_at_box box2 depot1)
        (be_at_box box3 depot1)
        (be_at_box box4 depot1)
        (be_at_box box5 depot1)
        (be_at_box box6 depot1)
        ; content initial position
        (be_at_content content1 depot1)
        (be_at_content content2 depot1)
        (be_at_content content3 depot1)
        (be_at_content content4 depot1)
        (be_at_content content5 depot1)
        (be_at_content content6 depot1)
        ; robot initial position
        (be_at_robot depot1 robot1)
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
        (not_assigned_carrier_box box1 carrier1)
        (not_assigned_carrier_box box2 carrier1)
        (not_assigned_carrier_box box3 carrier1)
        (not_assigned_carrier_box box4 carrier1)
        (not_assigned_carrier_box box5 carrier1)
        (not_assigned_carrier_box box6 carrier1)
        ; no content is assigned
        (not_is_assigned content1)
        (not_is_assigned content2)
        (not_is_assigned content3)
        (not_is_assigned content4)
        (not_is_assigned content5)
        (not_is_assigned content6)
        ; set capacity
        (= (carrier_capacity carrier1) 4)
        ; assign carrier
        (assigned_robot_carrier  carrier1 robot1)
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
