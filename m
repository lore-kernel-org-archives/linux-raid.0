From: Phil Turmel <philip@turmel.org>
Subject: Re: Please help RAID1 complete fail no superblock
Date: Tue, 22 Nov 2016 13:05:25 -0500
Message-ID: <65e5857b-9618-4f66-5f4b-c0e445de9088@turmel.org>
References: <856401.507833169-sendEmail@optimum>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <856401.507833169-sendEmail@optimum>
Sender: linux-raid-owner@vger.kernel.org
To: "theelectricengineer@gmail.com" <theelectricengineer@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Wols Lists <antlists@youngman.org.uk>, George Rapp <george.rapp@gmail.com>
List-Id: linux-raid.ids

Hi Yaniv,

{ Convention on kernel.org is to reply-to-all, trim quotes, and either
reply at the bottom or interleaved with the questions.  CC list
repaired. And please don't break threading. }

On 11/22/2016 11:24 AM, theelectricengineer@gmail.com wrote:

>>> One more piece of information that would be helpful is the partition
>>> tables for each drive:
>>>
>>> # fdisk -l /dev/sdb /dev/sdc

Per the warnings in the output, fdisk is not appropriate for your
drives.  You must use gdisk or parted:

gdisk -l /dev/sdb
gdisk -l /dev/sdc

parted /dev/sdb print
parted /dev/sdc print

Phil
