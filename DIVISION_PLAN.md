# Obla LLC — Faceless Channels Division · Operating Plan

**v1.5 · 2026-07-19 · Prepared by the Division Manager (Claude).**
Canonical copy for machine consumption. Mirrors the claude.ai artifacts; if this file and an artifact disagree, the newer date wins. Local sessions: write a copy to `~/faceless/DIVISION_PLAN.md` on the ProArt and keep it updated.

---

## §0 Owner directives (standing, all sessions)

1. **Talk less.** Short reports: decisions needed, results, nothing else. No narration, no essays.
2. **Honesty is the product.** The division brand is "check our work" — auditable, cited, publicly corrected. Never claim "unbiased"; claim verifiable.
3. **Quality mandate.** Presentation quality is the constraint; cost is the variable. No skimping on animation, sound design, or any element a good video needs. If expensive: (1) substitute cheaper tools at negligible quality loss, (2) buy hardware — never (3) cut the element.
4. **Authentic in content, excellent in presentation.** Facts, documents, testimonies, photos, lab results are never embellished — but staged with broadcast-grade craft. No generative AI video/imagery for evidence; real documents and licensed stock only. AI narration is disclosed.
5. **Owner does judgment only** (~2–4 h/week): topic veto, script voice pass, final cut approval, corrections. Everything else is pipeline.
6. **Trade secret:** method and infrastructure are never revealed publicly. Public entity: Obla LLC.

## §1 Portfolio & sequencing (decided)

One flagship, not five parallel launches. Sequence:

| # | Channel | Status | Stack |
|---|---------|--------|-------|
| CH-01 | **Primary Source** (renamed from "The Paper Trail" — ProPublica collision) | Flagship, launch first | Cloud + ElevenLabs |
| CH-02 | **Long Story** (owner-named) | Parallel, 1 ep / 6 weeks | Cloud + ElevenLabs |
| CH-03 | **Consensus** | Phase 2, month 5+, gated on CH-01 pipeline running clean | Cloud |
| CH-04 | **Autopsy** | Folded into CH-01 as a series; spins out if 2× channel avg views over 6 eps | — |
| CH-05 | **The Tech Desk** (working title) | Parallel, local stack, active now | ProArt local, $0/mo |

### CH-01 · Primary Source — *"Read the documents."*
Investigative stories reconstructed ONLY from primary documents (court filings, bankruptcy reports, hearing transcripts, FOIA). Every claim carries an on-screen citation chip `[DOC 04 · P.132]`; full doc list in description. 18–30 min, 1 per 2 weeks.
- **Voice: AI (ElevenLabs), locked voice ID, disclosed.** Decided by owner.
- Launch slate: Boeing 737 MAX (ep. 1, dossier below), FTX examiner reports, OceanGate Coast Guard hearings, Purdue Pharma unsealed filings, Quibi (Autopsy series), Theranos trial exhibits.
- ROI 24-mo scenarios: bear ~50% (<15k subs, ~$0), base ~35% (60–200k subs, $1.5–4.5k/mo), bull ~15% (500k+, $10k+/mo). RPM assumption $8–15. Monetization gate expected month 5–9.
- Name fallbacks if handle taken: Public Record, The Unsealed.

### CH-02 · Long Story
Ten slow-moving stories revisited annually, fixed format: promised / happened / prediction scorecard / next checkpoint. The archive is the moat. ~$40–80/ep.
Trackers (baseline July 2026): 
1. **iBIONICS Diamond Eye** (Ottawa; 256-electrode diamond retinal implant; clinical lead Dr. Flavio Rezende, Montreal; incorporated 2015, still not in patients) — channel ep. 1. 
2. **Next-gen GLP-1s**: orforglipron approved as *Foundayo* 2026-04-01; retatrutide TRIUMPH-1 28.3% mean weight loss, TRIUMPH-2/3 readouts late 2026; Viking VK2735 VANQUISH Ph3 underway, oral Ph3 late 2026. 
3. Fusion (CFS SPARC) · 4. Solid-state batteries (QuantumScape/Toyota) · 5. BCI (Neuralink/Synchron) · 6. California HSR · 7. Xenotransplantation · 8. CRISPR clinic (Casgevy) · 9. Starship · 10. Longevity drugs (Loyal/TAME). (3–10 = baselines to verify at production.)

### CH-03 · Consensus (Phase 2)
One contested question per episode; full literature synthesized; ends with "what would change this answer." Pilot slate: intermittent fasting, cold plunges, creatine/brain, screen time & kids, seed oils, GLP-1 muscle loss. Heavy research cost (~$60–120/ep). Sponsor filter: strict — no supplement junk.

### CH-05 · The Tech Desk (accepted 2026-07-19 from owner's local session handoff)
Honest, cited tech buying advice. One market per video (US first). Format library: decision-framework, persona story (Sam & Amanda), head-to-head, myth-buster, countdown. Equal airtime for budget picks. 
**Revenue: Amazon Associates affiliate — pays from video one, no YPP gate.**
Division amendments on acceptance:
1. **Autonomy earned:** first 5 videos pass owner gate; then fully automated with machine QC (citation check, image vet, loudness, render sanity) + weekly 5-min owner digest.
2. **Image sourcing:** Amazon /dp/ scraping is ToS gray zone — interim only, cache forever; switch to PA-API official images immediately after Associates approval; prefer manufacturer press images. NEVER ship an unvetted product image.
3. **Compliance:** automated FTC affiliate disclosure + AI-narration disclosure every description; per-video originality check (YouTube inauthentic-content policy).
4. **Category focus:** launch in wearables + phones + audio; broaden after traction.
Local pipeline facts (proven): root `~/faceless/` on ProArt (ssh rael@172.24.1.60, fish shell → wrap in `bash -c`, ship scripts via scp never inline); Piper voice en_US-hfc_female-medium LOCKED; Remotion renderer (Node 26: render API render.mjs, typescript@5.9.3, chromium gl:'swangle'); gemma3:4b as DESCRIBER not judge for image vetting; knockout = PNG corner floodfill `-fuzz 14% -draw 'color 2,2 floodfill'`; Pixabay key `~/faceless/.pixabay_key` (photos good, videos thin); `product_image.py` built, wiring into `remotion_prep.py` is the open task; then: expects into spec.json, persona-story template #2, Suno music, less "machiney" scripts, thumbnails (ask owner first).

## §2 Economics

- Budget confirmed: **~$400–550/mo average, ~$6,500 ceiling through month 9**, 90-day review.
- One-time setup: $600–1,200 (branding, render component library, motion-designer polish pass — green-lit, one-time — licensed SFX library).
- Editing cost per episode: ~$0 (programmatic Remotion render; no human editor — owner decision).
- Tool stack /mo: Claude $100–200 · ElevenLabs $22–99 · Storyblocks $30 · Epidemic $18 · PACER/CourtListener $10–30 · bot hosting $10–20. CH-05: $0 local.
- Kill criterion: if no episode breaks 10k views by month 9 → kill formats, not the division; re-pilot. Calendar, not vibes.

## §3 Production structure

- **L0 Owner (Orlin):** judgment only. Topic veto (5 min), script voice pass (~30 min), final cut (~15 min), corrections.
- **L1 Division Manager (Claude session):** pipeline orchestration, episode picks, script drafts, citation QC, analytics, one short weekly memo. HQ = Ubuntu bridge session; cloud session = strategy archive.
- **L2 Research agents (spawned by L1):** document sweeps, literature reviews, and a separate ADVERSARIAL fact-check pass that tries to refute every draft before the owner sees it.
- **L3 Bots/scripts (OpenClaw + cron):** docket watchers (CourtListener/RECAP), PubMed/ClinicalTrials monitors, upload+metadata, thumbnail A/B, analytics pulls, comment triage.
- **L-ext (one-time, green-lit):** motion-designer polish pass on the render template component library.

### Per-episode pipeline (10 working days, two episodes staggered → biweekly publish)
Day 0 topic pick (owner 5-min gate) → 1–3 document sweep (L2) → 3–4 script draft with scene markup `[SHOW doc04 p.132][HIGHLIGHT][CHIP][BROLL][BEAT]` (L1) → 4–5 adversarial pass (L2) → 5 owner voice pass → 6 TTS with word-level timestamps → 6–9 programmatic Remotion render (doc-cam zooms, highlight reveals, citation chips, animated data graphics, timeline/map components, music auto-ducking, SFX) → 9 owner final review → 10 bot publish (metadata, chapters, citation list, thumbnail A/B) → +7 retention retro memo.
- Quality gates asymmetric: facts machine-checked twice, taste human-checked twice.
- Failure stops the line, not the calendar: research runs one episode ahead; a gutted story gets swapped, never padded.
- Presentation standard: one idea per screen; documents enter with purpose (zoom to the exact line); restraint rule — a graphic that doesn't aid understanding or verification doesn't ship.

## §4 Episode 1 dossier — Boeing 737 MAX ("346 Deaths, Zero Convictions: The Boeing Documents")

Why now: criminal case DISMISSED 2025-11-06 (Judge O'Connor, skeptical opinion) under the 2025-05-29 non-prosecution agreement ($1.1B+: $444.5M victims fund, $455M compliance); Fifth Circuit mandamus decision 2026-03-31. Nearly all coverage predates the ending — we tell the complete 7-year story from documents alone.
Document map: DOC01 NTSC/Ethiopian AIB final crash reports · DOC02 internal Boeing messages Jan 2020 ("designed by clowns… supervised by monkeys") = cold open · DOC03 JATR review + House T&I final report Sept 2020 (245 pp) · DOC04 DOJ DPA Jan 2021 ($2.5B, statement of facts) · DOC05 Forkner indictment → acquittal Mar 2022 · DOC06 Alaska 1282 door plug + DOJ breach finding 2024 · DOC07 O'Connor rejects plea deal Dec 2024 · DOC08 NPA May 2025 · DOC09 dismissal Nov 2025 + Fifth Circuit Mar 2026.
Spec: 22–26 min, ~3,400 words. Editorial line: never say "got away with it" — put the DPA statement of facts next to the dismissal opinion and let the viewer hold both.

## §5 Decisions log

| Date | Decision |
|------|----------|
| 2026-07-19 | Portfolio sequencing: one flagship (CH-01), Long Story parallel, Consensus gated, Autopsy folded |
| 2026-07-19 | Voice: AI narration (ElevenLabs), disclosed |
| 2026-07-19 | Budget ~$550/mo → revised ~$400/mo after editor removed; $6.5k/9mo ceiling |
| 2026-07-19 | Names: Primary Source (ProPublica collision killed Paper Trail); Long Story (owner) |
| 2026-07-19 | Production AI end-to-end; no human editor; Remotion programmatic render |
| 2026-07-19 | No generative AI video for evidence; stock/archival only |
| 2026-07-19 | Quality mandate + presentation standard (owner directives) |
| 2026-07-19 | Talk-less communication rule (owner directive) |
| 2026-07-19 | CH-05 accepted with 4 amendments; local stack; ProArt = division render farm; Remotion component library shared across channels |

## §6 Owner one-time setup list (pending)

- [ ] Amazon Associates signup (CH-05; unlocks PA-API after 3 sales)
- [ ] YouTube channels: Primary Source, Long Story, Tech Desk (Google account) + OAuth credentials for auto-upload
- [ ] ElevenLabs, Storyblocks, Epidemic Sound subscriptions + API keys
- [ ] Artifacts (browser): plan https://claude.ai/code/artifact/c0802787-efe0-46c5-80cb-e6d1a98526d3 · week-1 package https://claude.ai/code/artifact/398770d0-c541-4b74-8369-66d41c6968fc
