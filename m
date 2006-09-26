From: "Tuomas Leikola" <tuomas.leikola@gmail.com>
Subject: Re: raid 1 recovery steps
Date: Tue, 26 Sep 2006 09:49:49 +0300
Message-ID: <5b170a7d0609252349y2f7a7617w6d9ce041a1264a02@mail.gmail.com>
References: <6473812.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6473812.post@talk.nabble.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: chapman <chris@datasetgo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 9/24/06, chapman <chris@datasetgo.com> wrote:
> Can I assume the disk is ok, just needs to be
> re-added to the array?

Not necessarily. You should look for logs indicating _why_ it is
marked bad. If you don't know how long it's been broken, you need some
monitoring system, like mdadm or logcheck.

This is most commonly caused by bad sectors. If you can re-add and
resync goes through without complaining, you're probably ok.

> I'm assuming I need to first remove sda1 from the raid then re-add it,
> correct?  If so, what are the specific steps?

mdadm /dev/md0 -r /dev/sda1
mdadm /dev/md0 -a /dev/sda1

> Can this be done safely on a
> live server without pulling the system down?

sure.

> How will this affect rebooting
> once completed - if at all?

Should not have any impact. At least if boot setup is ok.

> Any gotchas I should look out for?

Things get tricky if the other disk has stealthily become bad.

- tuomas
