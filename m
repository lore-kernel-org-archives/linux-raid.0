From: Brad Campbell <brad@wasp.net.au>
Subject: Raid-5 to Raid-6 conversion?
Date: Sun, 14 Mar 2004 17:49:51 +0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <405462FF.3000205@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

G'day all,

Just an idle thought.
I currently have 7 Maxtor Maxline-II 250GB SATA disks in a raid-5 array on kernel 2.4 on a pair of
highpoint 1540 controllers running the highpoint supplied module compiled from source with the raid
binary only compiled out. (Whew that was a long sentence)

I did investigate adding HPT support to libata, but a lack of time and confidence in my own skills
prompted me to invest in 3 Promise SATA150-TX4 controllers which are currently in transit.
(I gather these are far better supported in the stock kernel than highpoint stuff)

The crux of this is I'm going to max out my hardware capacity and add an extra 3 drives to this
array (Trusting my life to raidreconf to expand the array).
Is it feasible to at a later time add an extra disk and convert the raid-5 to a raid-6 on the fly ?

Secondly, I may not have the confidence to tackle the driver conversion, but I thought about perhaps
trying an addition to raidreconf to use a spare disk to journal it's progress to allow recovery from
power failure/bad sector or any other kind of error. It would slow the process quite a bit but it
has the potential to make it quite a bit more reliable.
Has anyone got any comments or ideas on this scheme before I plunge in and have a go. (I
conveniently have 6 spare WD2000JB drives with SATA converters floating about to test with)

Regards,
Brad

