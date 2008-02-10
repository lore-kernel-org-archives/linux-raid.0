From: David Greaves <david@dgreaves.com>
Subject: Re: when is a disk "non-fresh"?
Date: Sun, 10 Feb 2008 10:36:46 +0000
Message-ID: <47AED3BE.50606@dgreaves.com>
References: <200802030354.33435.Dexter.Filmore@gmx.de> <200802072316.20907.Dexter.Filmore@gmx.de> <18347.37564.207728.571946@notabene.brown> <200802081032.26044.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200802081032.26044.Dexter.Filmore@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Dexter Filmore <Dexter.Filmore@gmx.de>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dexter Filmore wrote:
> On Friday 08 February 2008 00:22:36 Neil Brown wrote:
>> On Thursday February 7, Dexter.Filmore@gmx.de wrote:
>>> On Tuesday 05 February 2008 03:02:00 Neil Brown wrote:
>>>> On Monday February 4, Dexter.Filmore@gmx.de wrote:
>>>>> Seems the other topic wasn't quite clear...
>>>> not necessarily.  sometimes it helps to repeat your question.  there
>>>> is a lot of noise on the internet and somethings important things get
>>>> missed... :-)
>>>>
>>>>> Occasionally a disk is kicked for being "non-fresh" - what does this
>>>>> mean and what causes it?
>>>> The 'event' count is too small.
>>>> Every event that happens on an array causes the event count to be
>>>> incremented.
>>> An 'event' here is any atomic action? Like "write byte there" or "calc
>>> XOR"?
>> An 'event' is
>>    - switch from clean to dirty
>>    - switch from dirty to clean
>>    - a device fails
>>    - a spare finishes recovery
>> things like that.
> 
> Is there a glossary that explains "dirty" and such in detail?

Not yet.

http://linux-raid.osdl.org/index.php?title=Glossary

David
