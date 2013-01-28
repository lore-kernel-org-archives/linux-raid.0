From: Wolfgang Denk <wd@denx.de>
Subject: Re: Huge values of mismatch_cnt on RAID 6 arrays under Fedora 18
Date: Mon, 28 Jan 2013 20:10:41 +0100
Message-ID: <20130128191041.8E962200607@gemini.denx.de>
References: <20130127192656.634892005AD@gemini.denx.de> <20130128173704.GA2329@lazy.lzy> <20130128190035.D943A294BAB@gemini.denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20130128190035.D943A294BAB@gemini.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Piergiorgio,

In message <20130128190035.D943A294BAB@gemini.denx.de> I wrote:
> 
> Found it.  Thanks for the suggestion.
> 
> However, this is extreme verbose:

OK, filtering this through "fgrep -v -e '->'" gives something like
this:

layout: 2
disks: 8
component size: 250058162176
total stripes: 15262339
chunk size: 16384

disk: 0 - offset: 1048576 - size: 250058301440 - name: /dev/sdj - slot: 7
disk: 1 - offset: 1048576 - size: 250058301440 - name: /dev/sdi - slot: 6
disk: 2 - offset: 1048576 - size: 250058301440 - name: /dev/sdh - slot: 5
disk: 3 - offset: 1048576 - size: 250058301440 - name: /dev/sdg - slot: 4
disk: 4 - offset: 1048576 - size: 250058301440 - name: /dev/sdf - slot: 3
disk: 5 - offset: 1048576 - size: 250058301440 - name: /dev/sde - slot: 2
disk: 6 - offset: 1048576 - size: 250058301440 - name: /dev/sdd - slot: 1
disk: 7 - offset: 1048576 - size: 250058301440 - name: /dev/sdc - slot: 0

Q(7) wrong at 1
P(5) wrong at 2
Q(6) wrong at 2
P(4) wrong at 3
Q(5) wrong at 3
P(3) wrong at 4
Q(4) wrong at 4
P(2) wrong at 5
Q(3) wrong at 5
P(1) wrong at 6
Q(2) wrong at 6
P(0) wrong at 7
Q(1) wrong at 7
P(7) wrong at 8
Q(7) wrong at 9
P(2) wrong at 541
Q(3) wrong at 541
P(1) wrong at 542
Q(2) wrong at 542
P(0) wrong at 543
Q(0) wrong at 544
P(6) wrong at 545
Q(7) wrong at 545
P(5) wrong at 546
Q(6) wrong at 546
P(4) wrong at 547
Q(5) wrong at 547
P(3) wrong at 548
Q(4) wrong at 548
P(2) wrong at 549
Q(3) wrong at 549
P(1) wrong at 550
Q(2) wrong at 550
P(0) wrong at 551
Q(0) wrong at 552
P(6) wrong at 553
Q(7) wrong at 553
P(5) wrong at 554
Q(6) wrong at 554
P(4) wrong at 555
Q(5) wrong at 555
P(3) wrong at 556
Q(4) wrong at 556
P(2) wrong at 557
Q(3) wrong at 557
P(1) wrong at 558
Q(2) wrong at 558
P(0) wrong at 559
Q(0) wrong at 560
P(6) wrong at 561
Q(7) wrong at 561
P(5) wrong at 562
Q(6) wrong at 562
P(4) wrong at 563
Q(5) wrong at 563
P(3) wrong at 564
Q(4) wrong at 564
P(2) wrong at 565
Q(3) wrong at 565
P(1) wrong at 566
Q(2) wrong at 566
P(0) wrong at 567
Q(0) wrong at 568
P(6) wrong at 569
Q(7) wrong at 569
P(5) wrong at 570
Q(6) wrong at 570
P(4) wrong at 571
Q(5) wrong at 571
P(3) wrong at 572
Q(4) wrong at 572
P(2) wrong at 573
Q(3) wrong at 573
P(1) wrong at 574
Q(2) wrong at 574
P(0) wrong at 575
Q(0) wrong at 576
P(6) wrong at 577
Q(7) wrong at 577
P(5) wrong at 578
Q(6) wrong at 578
P(4) wrong at 579
Q(5) wrong at 579
P(3) wrong at 580
Q(4) wrong at 580
P(2) wrong at 581
Q(3) wrong at 581
P(1) wrong at 582
...

etc. etc. [The test is still running, but I already have more than
10k such lines...]

What does this tell us?




Note:  on one system (where I can recreate / rstore the content of the
array more easily) I decided to play some experiments, so I ran a
"repair" on the array.  The repair completed without any error
indicateion - but ended with a mismatch_cnt = 362731480.

My simple tests still ndicate no data corrption (but then I might just
be looking in the wrong places).


Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
It is a human characteristic to love little  animals,  especially  if
they're attractive in some way.
	-- McCoy, "The Trouble with Tribbles", stardate 4525.6
