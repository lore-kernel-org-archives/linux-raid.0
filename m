From: Matt Callaghan <matt_callaghan@sympatico.ca>
Subject: mdadm RAID6 "active" with spares and failed disks; need help
Date: Tue, 6 Jan 2015 09:16:52 -0500
Message-ID: <BLU436-SMTP193F87969B47A13A1B33FCF81590@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I think I'm in a really bad state. Could an expert w/ mdadm please help?

I have a RAID6 mdadm device, and it got really messed up with spares:
{{{
md2000 : active raid6 sdm1[8](S) sdo1[3] sdi1[4] sdn1[2] sdk1[0](F) 
sdl1[6] sdp1[7]
       11721080448 blocks super 1.1 level 6, 64k chunk, algorithm 2 
[8/5] [__UU_UUU]
}}}

And is now really broken (inactive)
{{{
md2000 : inactive sdn1[2](S) sdm1[8](S) sdl1[6](S) sdp1[7](S) sdi1[4](S) 
sdo1[3](S) sdk1[0](S)
       13674593976 blocks super 1.1
}}}

I have a forum post going w/ full details
http://www.linuxquestions.org/questions/linux-server-73/mdadm-raid6-active-with-spares-and-failed-disks%3B-need-help-4175530127/

I /think/ I need to force re-assembly here, but I'd like some review 
from the experts before proceeding.

Thank you in advance for your time,
~Matt/Fermulator
