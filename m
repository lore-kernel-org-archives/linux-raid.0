From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID5+spare volume gone - mdadm sees RAID1 only?
Date: Mon, 23 Sep 2013 08:40:10 -0400
Message-ID: <524036AA.20703@turmel.org>
References: <CAFjqtwhDa03Yi2kaWAVCVpYPxPmF3omwAw2KW4cmKfQerXFwug@mail.gmail.com> <523F6512.2050007@turmel.org> <CAFjqtwhbSAmXKSjFkmL+f342uJWPQdWbdXCNu7s5B03X=F0wdg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFjqtwhbSAmXKSjFkmL+f342uJWPQdWbdXCNu7s5B03X=F0wdg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: P Agenbag <internet@mweb.co.za>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good morning,

[Please trim replies, and avoid top-posting]

On 09/23/2013 01:15 AM, P Agenbag wrote:
> Hi Phil
> 
> Below, please find the output of the mdadm --examine on the 4 drive's
> second partitions. Apologies for omitting that in the first e-mail.
> 
> Appreciate your help.

[trim /]

So it appears /dev/sd[abc]2 all dropped out together, leaving sdd2 by
itself.  As such, you should be able to force assembly and carry on.

mdadm -Af /dev/md1 /dev/sd[abcd]2

Then you can take a backup of the critical contents, if necessary.  (You
haven't said how important the data is...)

Phil


