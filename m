From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: Question
Date: Fri, 7 Feb 2020 16:53:45 +0100
Message-ID: <b75c2dc2-d14e-39dc-0c06-7bab53fa7cb8@thelounge.net>
References: <CAPpdf5-FJ0cP36pOLm40ESBOws8x5R6XbUOssFFCsY6xtb4_xw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPpdf5-FJ0cP36pOLm40ESBOws8x5R6XbUOssFFCsY6xtb4_xw@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: o1bigtenor <o1bigtenor@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



Am 07.02.20 um 16:49 schrieb o1bigtenor:
> Running a Raid-10 array made up of 4 - 1 TB drives on a debian testing
> (11) system.
> mdadm - v4.1 - 2018-10-01 is the version being used.
> 
> Some weirdness is happening - - - vis a vis - - - I have one directory
> (not small) that has disappeared. I last accessed said directory
> (still have the pdf open which is how I could get this information)
> 'Last accessed 2020-01-19 6:32 A.M.'  as indicated in the 'Properties'
> section of the file in question.
> 
> Has been suggested to me that I make the array read only until this is resolved.
> I have space on the the array on a different system to recover this array.
> Suggestions on how to do both of the above would be aprreciated

directories on a filesystem on top of a RAID don't disappear silently -
my bet is a simple drag&drop move or deletion aka PEBCAK
