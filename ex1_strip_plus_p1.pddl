(define (problem ex1_strip_plus_p1)
    (:domain ex1_strip_plus)
    ; OBJECT DEFINITIONS
    (:objects
       depot - location ;; our initial depot
       location1 - location ;; other location avaiable
       robot1 - robot ;; our agent
       box1 box2 box3 - box ;; three box avaiable
       person1 - person ;; person to be rescued
       ; content to be delivered
       content1 - food
       content2 - tool
       content3 - medicine
    )
    ; PREDICATE DEFINITIONS
    (:init
        ; all box, content, agent at depot initially
        ; box initial position
        (be_at_box box1 depot)
        (be_at_box box2 depot)
        (be_at_box box3 depot)    
        ; content initial position
        (be_at_content content1 depot)
        (be_at_content content2 depot)
        (be_at_content content3 depot)
        ; robot initial position
        (be_at_robot depot robot1)
        ; people initial position
        (be_at_person location1 person1)
        ; note that robot and box must be empty
        (empty_robot robot1)
        ; box initial empty
        (empty_box box1)
        (empty_box box2)
        (empty_box box3)
        (not_is_assigned_box box1)
        (not_is_assigned_box box2)
        (not_is_assigned_box box3)
        ; is necessary to set true negated version of predicates
        ; no content is assigned to anyone
        (not_assigned_person_content content1 person1)
        (not_assigned_person_content content2 person1)
        (not_assigned_person_content content3 person1)
        ; no box is full
        (not_assigned_box_content box1 content1)
        (not_assigned_box_content box2 content1)
        (not_assigned_box_content box3 content1)
        (not_assigned_box_content box1 content2)
        (not_assigned_box_content box2 content2)
        (not_assigned_box_content box3 content2)
        (not_assigned_box_content box1 content3)
        (not_assigned_box_content box2 content3)
        (not_assigned_box_content box3 content3)
        ; no box is assigned to any robot 
        (not_assigned_robot_box box1 robot1)
        (not_assigned_robot_box box2 robot1)
        (not_assigned_robot_box box3 robot1)
        ; no content is assigned
        (not_is_assigned content1)
        (not_is_assigned content2)
        (not_is_assigned content3)
    )
    ; GOAL DEFINITIONS
    (:goal 
        (and
            (assigned_person_content content1 person1)
            (assigned_person_content content2 person1)
            (assigned_person_content content3 person1)
        )
    )
)
