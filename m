From: Nate Dailey <nate.dailey@stratus.com>
Subject: raid1 IO hang - md_submit_flush_data ignores md_write_start return
 value
Date: Wed, 20 Sep 2017 08:49:30 -0400
Message-ID: <b3764c9a-5a43-d901-a0ef-5a6989e8e81d@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm seeing an occasional XFS IO hang with raid1 (INFO: task xfsaild/md20:17963 
blocked for more than 120 seconds).

It turns out that this is because md_submit_flush_data calls pers->make_request, 
and doesn't check the return value (unlike md_make_request, which checks the 
return value and retries). So if raid1_make_request/md_write_start return false, 
md_submit_flush_data drops the write on the floor.

I'm hitting this on a RHEL kernel, but looking at the upstream code it appears 
that the same thing could happen.

Not sure how best to deal with this... thank you for any advice!

Nate


