From: Larkin Lowrey <llowrey@gmail.com>
Subject: Raid5/6 journal re-add
Date: Sun, 19 Nov 2017 18:00:20 -0500
Message-ID: <4752eee7-7b05-55fc-9e0b-d9446ef4328d@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I did a 'pull-the-drive' test on a raid6 array with a write-journal and 
found that mdadm (v4.0-218-gfe05dc4 - 2017-11-09) would not let me 
--re-add the drive so I add to --add it.

mdadm: --re-add for /dev/sdq1 to /dev/md124 is not possible

My expectation was that the drive would be recognized as being the 
missing member and would be re-added and only out-of-sync regions would 
be resync'd.

When I --add'ed the drive to the array the resync process started for 
the entire array, not just for the out-of-sync regions. Is this correct 
behavior for arrays with write journals? Are there plans to perform a 
selective re-sync rather than a full re-sync?

--Larkin
