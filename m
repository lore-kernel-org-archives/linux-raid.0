From: Anthonys Lists <antlists@youngman.org.uk>
Subject: Re: Reassembling RAID1 after good drive was offline [newbie]
Date: Fri, 02 Jan 2015 11:01:32 +0000
Message-ID: <54A67A8C.8080803@youngman.org.uk>
References: <20150101174048.GB4840@deb76.aryehleib.com> <54A5B409.8040501@tigertech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54A5B409.8040501@tigertech.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/01/2015 20:54, Robert L Mathews wrote:
>> Personalities : [raid1]
>> >md126 : active (auto-read-only) raid1 sdc2[0]
>> >       943587136 blocks super 1.2 [2/1] [U_]
>> >       
>> >md127 : active (auto-read-only) raid1 sdd2[1]
>> >       943587136 blocks super 1.2 [2/1] [_U]
> Still sdc2 and sdd2, although now in two arrays.
>
>
What version is mdadm? iirc there is a known bug in older versions which 
does this. (Splits one array into two arrays.)

Cheers,
Wol
