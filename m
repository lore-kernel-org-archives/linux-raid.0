From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: checkarray not running or emailing
Date: Thu, 12 Mar 2020 17:17:16 +0800
Message-ID: <61f5fc7b-bd2a-a151-a228-3d2a6f4d3ee6@fnarfbargle.com>
References: <814aad65-fba3-334c-c4df-6b8f4bfc4193.ref@att.net>
 <814aad65-fba3-334c-c4df-6b8f4bfc4193@att.net>
 <0ef54c89-b486-eb0b-8d70-a043ef089c9f@att.net>
 <10e2db3d-13e6-573f-18bd-1443d6a27884@fnarfbargle.com>
 <7ba840ec-74fd-96bf-5088-7f8479ddcba5@att.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7ba840ec-74fd-96bf-5088-7f8479ddcba5@att.net>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lesrhorer@att.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On 12/3/20 09:41, Leslie Rhorer wrote:
>     Aha! There it is, on both the old and new systems, so it probably is running.  The question remains, "Why isn't it posting to email?"
>
root@srv:~# mdadm --monitor --test --oneshot /dev/md2
mdadm: Monitor using email address "root" from config file

And in the mail :

This is an automatically generated mail message from mdadm
running on srv

A TestMessage event had been detected on md device /dev/md2.

Faithfully yours, etc.

P.S. The /proc/mdstat file currently contains the following:

Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md2 : active raid1 nvme0n1[2] md5[3](W)
       952696320 blocks super 1.2 [2/2] [UU]
       bitmap: 6/8 pages [24KB], 65536KB chunk



Brad

-- 
An expert is a person who has found out by his own painful
experience all the mistakes that one can make in a very
narrow field. - Niels Bohr
