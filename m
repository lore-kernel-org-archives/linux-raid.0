From: David T-G <davidtg-robot@justpickone.org>
Subject: Re: re-add syntax
Date: Thu, 21 May 2020 09:15:00 -0400
Message-ID: <20200521131500.GP1415@justpickone.org>
References: <20200520200514.GE1415@justpickone.org>
 <5EC5BBEF.7070002@youngman.org.uk>
 <20200520235347.GF1415@justpickone.org>
 <5EC63745.1080602@youngman.org.uk>
 <20200521110139.GW1711@justpickone.org>
 <20200521112421.GK1415@justpickone.org>
 <5EC66D4E.8070708@youngman.org.uk>
 <20200521123306.GO1415@justpickone.org>
 <828a3b59-f79c-a205-3e1e-83e34ae93eac@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <828a3b59-f79c-a205-3e1e-83e34ae93eac@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Wol, et al (is there anyone else, even??) --

...and then antlists said...
% 
% On 21/05/2020 13:33, David T-G wrote:
% >% Can't remember the syntax, but there's a re-add option. If it can find
% >% and replay a log of failed updates, it will bring the drive straight
% >% back in. Otherwise it will rebuild from scratch.
% >%
% >% That's probably the safest way - let mdadm choose the best option.
% >
% >OK; yay.  I'm still confused, though, between "add" and "readd".  I'll
% >take any pointers to docs I can get.
% 
% Add just adds the drive back and rebuilds it.
% 
% Readd will play a journal if it can. If it can't, it will fall back
% and do an add.

OK.  Sounds good.


% 
% So *you* should choose re-add. Let mdadm choose add if it can't do a re-add.

Thanks.  Sooooo ...  Given this

  diskfarm:root:10:~> cat /proc/mdstat                                                                                            
  Personalities : [raid6] [raid5] [raid4] 
  md0 : active raid5 sdb1[0] sda1[4] sdc1[3]
        11720265216 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/3] [U_UU]
        
  md127 : active raid5 sdf2[0] sdg2[1] sdh2[3]
        1464622080 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3] [UUU]
        
  unused devices: <none>

  diskfarm:root:10:~> mdadm --examine /dev/sd[abcd]1 | egrep '/dev/sd|Event'
  /dev/sda1:                                                                                                                      
           Events : 57862
  /dev/sdb1:                                                                                                                      
           Events : 57862
  /dev/sdc1:                                                                                                                      
           Events : 57862
  /dev/sdd1:                                                                                                                      
           Events : 48959

does this

  mdadm --manage /dev/md0 --re-add /dev/sdd1

look like the right next step?


% 
% Cheers,
% Wol


Thanks again & HAND

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt
