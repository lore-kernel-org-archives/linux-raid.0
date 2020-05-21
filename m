From: antlists <antlists@youngman.org.uk>
Subject: Re: re-add syntax (was "Re: failed disks, mapper, and "Invalid
 argument"")
Date: Thu, 21 May 2020 14:01:08 +0100
Message-ID: <828a3b59-f79c-a205-3e1e-83e34ae93eac@youngman.org.uk>
References: <20200520200514.GE1415@justpickone.org>
 <5EC5BBEF.7070002@youngman.org.uk> <20200520235347.GF1415@justpickone.org>
 <5EC63745.1080602@youngman.org.uk> <20200521110139.GW1711@justpickone.org>
 <20200521112421.GK1415@justpickone.org> <5EC66D4E.8070708@youngman.org.uk>
 <20200521123306.GO1415@justpickone.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200521123306.GO1415@justpickone.org>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: David T-G <davidtg-robot@justpickone.org>, Linux RAID list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 21/05/2020 13:33, David T-G wrote:
> % Can't remember the syntax, but there's a re-add option. If it can find
> % and replay a log of failed updates, it will bring the drive straight
> % back in. Otherwise it will rebuild from scratch.
> %
> % That's probably the safest way - let mdadm choose the best option.
> 
> OK; yay.  I'm still confused, though, between "add" and "readd".  I'll
> take any pointers to docs I can get.

Add just adds the drive back and rebuilds it.

Readd will play a journal if it can. If it can't, it will fall back and 
do an add.

So *you* should choose re-add. Let mdadm choose add if it can't do a re-add.

Cheers,
Wol
