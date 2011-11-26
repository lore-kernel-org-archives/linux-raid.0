From: Ronal Andadinata <randadinata@gmail.com>
Subject: mdadm, bitmap and split-brain
Date: Sun, 27 Nov 2011 03:28:31 +0700
Message-ID: <4ED14BEF.2060301@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm wondering, in the case of raid1 array with internal bitmap, it goes 
like this :
1. Machine A has 1 raid1 array with Disk1 dan Disk2
2. Dettach Disk2 from Machine A, put it on Machine B
3. Machine A runs normally, Machine B runs on normally on different place.
4. Detach Disk2 from Machine B, put it back on Machine A, re-add Disk2 
to md1

If this were raid1 without bitmap, Disk2 will be overwritten from 
scratch with contents of Disk1, what happen if the array has bitmap ? 
Would there be partial sync ? Would the two disk be identical with only 
using partial sync ?
