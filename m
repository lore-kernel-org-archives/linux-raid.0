From: Phil Turmel <philip@turmel.org>
Subject: Re: Converting 4 disk RAID10 to RAID5
Date: Tue, 27 Oct 2015 08:13:43 -0400
Message-ID: <562F6A77.20502@turmel.org>
References: <562D8142.80507@websitemanagers.com.au>
 <562E345D.5030206@turmel.org> <562EBD58.2040306@websitemanagers.com.au>
 <562F1789.9080000@gmail.com> <562F1A61.6010709@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <562F1A61.6010709@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>, Anugraha Sinha <asinha.mailinglist@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/27/2015 02:32 AM, Adam Goryachev wrote:
> On 27/10/15 17:19, Anugraha Sinha wrote:
\
>> This will restart your array with the required raid-level and also
>> start the resyncing process.

You shouldn't have needed to stop it.

> I got:
> mdadm: Failed to restore critical section for reshape, sorry.
> Possibly you needed to specify the --backup-file

Probably just need "mdadm /dev/md0 --grow --continue --backup-file=...."

where .... is a file location outside the array.  You may also need
--invalid-backup

Phil
