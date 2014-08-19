From: Markus Stockhausen <stockhausen@collogia.de>
Subject: [PATCH v2 0/6] raid6: support read-modify-write
Date: Tue, 19 Aug 2014 16:36:20 +0000
Message-ID: <677cbe3b-4301-4650-962a-043f6ae59086@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-f4d433e5-b8b8-48b3-8229-6ae394d0477d"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


This is a multi-part message in MIME format.

------=_NextPartTM-000-f4d433e5-b8b8-48b3-8229-6ae394d0477d
Content-Type: text/plain

v2: reordering and merging of patches as Neil requested. More
verification & benchmark numbers

Once again thanks to an older patch from Kumar Sundararajan and 
Dan Williams that helped me to understand RAID6 logic inside md 
better. Everything is based on ideas & discussions that started
with http://marc.info/?l=linux-raid&m=136624783417452&w=1

Another try to implement RMW support for RAID6. This time improve
syndrome calculation too. A few things to note:

1) Patches are based on official 3.16 kernel git.

2) The required optimized syndrome functions were implemented if
possible. Generic & SSE2 are the ones that I could write & test
on my machine. If you want to test/benchmark this patch ensure
that you force select one of the two. Programmers with appropriate
hardware in their hands are encouraged to send the missing 
algorithms.

3) raid6 test program was enhanced to verify algorithm correctness. 
Additionaly this release was checked with a self written single 
threaded test tool I called wprd (write predictable random data).
Checked features include raid expansion, rebuild of failed drives, 
different RAID6 geometries, ... /dev/md0 and the underlying block
devices contents were checked with sha256sum against an expected 
result of the unpatched module. Knock on wood so far no failures.

4) In between I was able to grab 10 older disk drives of different 
sizes and speeds and built a test rig. Simple RAID math should
give 3read+3write I/Os for RMW and 7read+3write I/Os for RCW and
thus a 66% improvement for write I/Os with a size smaller or
equal to a single chunk. As you can see reality does not care 
about math but the effect is visible. Remember that larger arrays
will show more speedups.

300 seconds random write with 8 threads
3,2TB (10*400GB) RAID6 64K chunk without spare 
group_thread_cnt=4

bsize   rmw_level=1   rmw_level=0   rmw_level=1   rmw_level=0
        skip_copy=1   skip_copy=1   skip_copy=0   skip_copy=0
   4K      115 KB/s      141 KB/s      165 KB/s      140 KB/s
   8K      225 KB/s      275 KB/s      324 KB/s      274 KB/s
  16K      434 KB/s      536 KB/s      640 KB/s      534 KB/s
  32K      751 KB/s    1,051 KB/s    1,234 KB/s    1,045 KB/s
  64K    1,339 KB/s    1,958 KB/s    2,282 KB/s    1,962 KB/s
 128K    2,673 KB/s    3,862 KB/s    4,113 KB/s    3,898 KB/s
 256K    7,685 KB/s    7,539 KB/s    7,557 KB/s    7,638 KB/s
 512K   19,556 KB/s   19,558 KB/s   19,652 KB/s   19,688 Kb/s

Thanks Neil for your support.

Markus


------=_NextPartTM-000-f4d433e5-b8b8-48b3-8229-6ae394d0477d
Content-Type: text/plain;
	name="InterScan_Disclaimer.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="InterScan_Disclaimer.txt"

****************************************************************************
Diese E-Mail enthält vertrauliche und/oder rechtlich geschützte
Informationen. Wenn Sie nicht der richtige Adressat sind oder diese E-Mail
irrtümlich erhalten haben, informieren Sie bitte sofort den Absender und
vernichten Sie diese Mail. Das unerlaubte Kopieren sowie die unbefugte
Weitergabe dieser Mail ist nicht gestattet.

Über das Internet versandte E-Mails können unter fremden Namen erstellt oder
manipuliert werden. Deshalb ist diese als E-Mail verschickte Nachricht keine
rechtsverbindliche Willenserklärung.

Collogia
Unternehmensberatung AG
Ubierring 11
D-50678 Köln

Vorstand:
Kadir Akin
Dr. Michael Höhnerbach

Vorsitzender des Aufsichtsrates:
Hans Kristian Langva

Registergericht: Amtsgericht Köln
Registernummer: HRB 52 497

This e-mail may contain confidential and/or privileged information. If you
are not the intended recipient (or have received this e-mail in error)
please notify the sender immediately and destroy this e-mail. Any
unauthorized copying, disclosure or distribution of the material in this
e-mail is strictly forbidden.

e-mails sent over the internet may have been written under a wrong name or
been manipulated. That is why this message sent as an e-mail is not a
legally binding declaration of intention.

Collogia
Unternehmensberatung AG
Ubierring 11
D-50678 Köln

executive board:
Kadir Akin
Dr. Michael Höhnerbach

President of the supervisory board:
Hans Kristian Langva

Registry office: district court Cologne
Register number: HRB 52 497

****************************************************************************

------=_NextPartTM-000-f4d433e5-b8b8-48b3-8229-6ae394d0477d--
