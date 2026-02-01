# Shiva Concepts: A Dummies Guide

So you want to understand the brain of the machine? This guide breaks down how Shiva "Senses, Thinks, and Acts," and how you can tweak its behavior.

---

## Part 1: The Brain (Sense-Think-Act)

Shiva runs on a continuous **Loop** that happens roughly 5-10 times per second. In every single cycle, it follows this exact pattern:

### 1. Sense (Availability)
First, Shiva looks at **every single known action** (Kill, Heal, Loot, Rest, etc.) and asks one question: *"Can I do this right now?"*

This is the `available?` check found in every action file.
*   **Example (Unstun)**: "Is a party member stunned? Do I have mana?"
*   **Example (Kill)**: "Is there a monster in the room? Is it not dead yet?"

If the answer is **NO**, the action is thrown out for this cycle.
If the answer is **YES**, it goes to the "Shortlist".

### 2. Think (Priority)
Now Shiva has a "Shortlist" of things it *could* do. It needs to decide what it *should* do.

It sorts the Shortlist by **Priority Number**.
*   **Lower Number = MORE URGENT.**
*   **Higher Number = LESS URGENT.**

**Example Ranking:**
1.  **Unstun (Priority 4)**: "EMERGENCY! Helper is stunned!"
2.  **Heal (Priority 10)**: "Health is kinda low."
3.  **Kill (Priority 101)**: "Attack the goblin."
4.  **Loot (Priority 200)**: "Pick up the gem."

If you can **Unstun** and **Kill** at the same time, Shiva sees that **4 < 101**, so it chooses **Unstun**.

### 3. Act (Apply)
Once the winner is picked, Shiva stops thinking and **Acts**.

It calls the `apply` method for that action.
*   **Unstun**: Casts *Unstun* spell at the target.
*   **Kill**: Sends `attack` command to the game.

Once the action is done, the cycle restarts from the beginning.

---

## Part 2: Tinkering (Reconfigure & Priority)

Configuring Shiva isn't just about settings files; sometimes you want to change **Behavior**.

### Changing Priority
"I want Shiva to prioritize **Looting** over **Killing**!"

1.  Find the action file (e.g., `actions/support/loot.rb` or `actions/combat/kill.rb`).
2.  Look for the `def priority` method.
3.  Change the number.

**Original Kill:**
```ruby
def priority
  101
end
```

**Modified Kill (Lazy):**
```ruby
def priority
  500  # Now I'm lazier than Looting (if Loot is 200)!
end
```

### Changing Logic (Sense)
"I only want to **Headbutt** if I have full stamina!"

1.  Find `actions/combat/headbutt.rb`.
2.  Look for the `available?` method.
3.  Add your extra condition.

**Original:**
```ruby
def available?(foe)
  Tactic.brawling? # Only if I'm a brawler
end
```

**Modified:**
```ruby
def available?(foe)
  Tactic.brawling? and
  Checkstamina.max == Checkstamina.current # Only at 100% stamina
end
```

---

## Summary
*   **Sense**: `available?` (True/False)
*   **Think**: `priority` (Number sorting)
*   **Act**: `apply` (Do it)

If Shiva isn't doing what you want, it's either because it thinks it **can't** (Available is false) or because something else is **more important** (Priority is lower number).
