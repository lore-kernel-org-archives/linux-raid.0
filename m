From: Hubert Verstraete <hubskml@free.fr>
Subject: RAID5 initial resync: faster vs more secure
Date: Thu, 20 Mar 2008 17:58:19 +0100
Message-ID: <47E297AB.8020001@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi list

Each time I create a RAID5 array, by default, as a degraded array with a 
spare, I cannot stop and restart the array unless the initial resync has 
completed. If I do so, the resync is not resumed when the array is 
re-assembled.
Is this due to the fact that one disk is a spare, but md actually 
doesn't know which of the disks is the spare one ?

Assuming that there is no bug and no workaround about this issue, I 
think the following: when one cannot guarantee the array won't be 
stopped until the resync completes, one should better create the RAID5 
array with the -f option. Indeed, when I use -f, I can stop the array 
and restart it, the resync will be resumed where it had stopped.
The cost of this is that the initial resync runs slower.

Comments are welcome.

Thanks,
Hubert

PS: the reshape patch from Neil on 03/03/08 does not fix the issue.
