From: Gionatan Danti <g.danti@assyoma.it>
Subject: On URE and RAID rebuild - again!
Date: Wed, 30 Jul 2014 10:29:36 +0200
Message-ID: <53D8ACF0.1070202@assyoma.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: g.danti@assyoma.it
List-Id: linux-raid.ids

Hi all,
I recently "scrubbed" the linux-raid list on URE and found some very 
interesting informations [1]. However, I don't have a definite answer on 
UREs and their effect on a RAID system, especially during rebuild - so 
be patient my me, please :)

1) From what I know, URE rate is measured in events per bit read. This 
means that a drive rated with a URE of "<10 in 10^-16" [2] will have 
less than 10 unreadable sectors per 1 PB read, or less than 1 URE event 
per 100 TB read. Moreover, when an URE happens the entire sector will be 
"lost". So, in the example above, with 512B sectors, I can "lost" 512B 
per 100TB.
QUESTION n.1: Is this explanation correct?

2) The URE rate measure a probability or it is a statistical record? In 
the first case (URE is a probability) even a relatively high URE rate of 
10^-14 is not traduced in "surely it will happen each 12 TB read", but 
in "you have ~63% an URE will happen". However is URE rate is the result 
of statistical evidence I can be quite sure that it will bite me at 
about 12.5 TB read. Sure this is an oversimplification, but I hope to be 
sufficiently clear here :)
QUESTION n.2: URE define a probability or a statistical evidence?

3) From what I understand having read some other mails, in the case of 
URE during RAID rebuild mdadm will _stop_ the rebuild and inform you of 
what happened. However, you could re-start the array, remount it and try 
to recover data via normal filesystem copy. If, and when, the filesystem 
will try to read the data affected by URE, mdadm will report back to it 
a "read error" and the filesystem can react as it want (re-try the copy, 
report back to user, abort the copy, etc.)
QUESTION n.3: is it what really happen on parity RAID (5,6)?
QUESTION n.4: what about mirror-striped array as RAID10? They follow the 
same behavior?

Thank you all and sorry for the lengthy mail!


[1] http://marc.info/?l=linux-raid&m=139025054501419&w=2
[2] http://www.wdc.com/wdproducts/library/SpecSheet/ENG/2879-771444.pdf

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
