From: Sarah Newman <srn@prgmr.com>
Subject: Re: Question
Date: Fri, 7 Feb 2020 14:50:23 -0800
Message-ID: <7af58e5b-7047-a3a8-f4b2-840ea6851dea@prgmr.com>
References: <CAPpdf5-FJ0cP36pOLm40ESBOws8x5R6XbUOssFFCsY6xtb4_xw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPpdf5-FJ0cP36pOLm40ESBOws8x5R6XbUOssFFCsY6xtb4_xw@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: o1bigtenor <o1bigtenor@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 2/7/20 7:49 AM, o1bigtenor wrote:
> Greetings
> 
> Running a Raid-10 array made up of 4 - 1 TB drives on a debian testing
> (11) system.
> mdadm - v4.1 - 2018-10-01 is the version being used.
> 
> Some weirdness is happening - - - vis a vis - - - I have one directory
> (not small) that has disappeared. I last accessed said directory
> (still have the pdf open which is how I could get this information)
> 'Last accessed 2020-01-19 6:32 A.M.'  as indicated in the 'Properties'
> section of the file in question.

I assume you've looked at lsof?

https://www.linux.com/news/bring-back-deleted-files-lsof/

If it is a software problem, it just as likely, if not more likely, that it is a file system problem rather than a raid problem. You don't mention 
what file system. You're possibly also actually looking at data in the in-memory disk cache rather than what's actually stored on disk given there's 
been no reboot.

Is there anything suspicious in dmesg?
