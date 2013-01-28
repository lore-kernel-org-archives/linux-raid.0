From: Wolfgang Denk <wd@denx.de>
Subject: Re: Huge values of mismatch_cnt on RAID 6 arrays under Fedora 18
Date: Mon, 28 Jan 2013 20:00:35 +0100
Message-ID: <20130128190035.D943A294BAB@gemini.denx.de>
References: <20130127192656.634892005AD@gemini.denx.de> <20130128173704.GA2329@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20130128173704.GA2329@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Piergiorgio,

In message <20130128173704.GA2329@lazy.lzy> you wrote:
>
> I would shamelessly suggest to try "raid6check", in order
> to see if some components have problems.
> 
> The software is somehow buried into "mdadm" source code,
> probably you'll need to take it from the repository.

Found it.  Thanks for the suggestion.

However, this is extreme verbose:

layout: 2
disks: 8
component size: 249108103168
total stripes: 15204352
chunk size: 16384

disk: 0 - offset: 134217728 - size: 250864926720 - name: /dev/sdk1 -
slot: 5
disk: 1 - offset: 134217728 - size: 250864926720 - name: /dev/sdj1 -
slot: 4
disk: 2 - offset: 134217728 - size: 250864926720 - name: /dev/sdi1 -
slot: 7
disk: 3 - offset: 134217728 - size: 250864926720 - name: /dev/sdh1 -
slot: 3
disk: 4 - offset: 134217728 - size: 250864926720 - name: /dev/sdg1 -
slot: 2
disk: 5 - offset: 134217728 - size: 250864926720 - name: /dev/sdf1 -
slot: 1
disk: 6 - offset: 134217728 - size: 250864926720 - name: /dev/sde1 -
slot: 6
disk: 7 - offset: 134217728 - size: 250863844352 - name: /dev/sdd1 -
slot: 0

pos --> 0
0->1
1->2
2->3
3->4
4->5
5->6
pos --> 1
0->0
1->1
2->2
3->3
4->4
5->5
pos --> 2
0->7
1->0
2->1
3->2
4->3
5->4
pos --> 3
0->6
1->7
2->0
3->1
4->2
5->3
pos --> 4
0->5
1->6
2->7
3->0
4->1
5->2
pos --> 5
...

etc. ad nauseam.  I guess "pos" means stripe here, so it would print
this for all stripes in the array?  Does this means all of them are
broken?  Or what would I  have to look for to see where an error
mightbe?

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
Our OS who art in CPU, UNIX be thy name.
Thy programs run, thy syscalls done,
In kernel as it is in user!
