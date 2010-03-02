From: Asdo <asdo@shiftmail.org>
Subject: Re: Why does one get mismatches?
Date: Wed, 03 Mar 2010 00:27:25 +0100
Message-ID: <4B8D9EDD.2080300@shiftmail.org>
References: <20100218100547.7aecdc34@notabene.brown> <4B853BBF.7000607@tmr.com>
 <yq1ocjemx46.fsf@sermon.lab.mkp.net> <20100225083936.07cd48ad@notabene.brown>
 <20100228080949.GA30574@maude.comedia.it>
 <20100302160100.621f9811@notabene.brown>
 <20100302073624.GA28827@maude.comedia.it>
 <4877c76c1003020204r477e942fo8ada66e1e9426295@mail.gmail.com>
 <20100302110232.GA14131@maude.comedia.it> <4B8D5581.8070509@shiftmail.org>
 <20100302185216.GB2243@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20100302185216.GB2243@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Piergiorgio Sartor wrote:
> Hi,
>   
>> Now it would be interesting to understand why the mismatches don't
>> happen when LVM is above MD-raid!?
>>     
>
> well, maybe LVM copies the buffer, and after it
> plays it nice with MD, i.e. no changes on the fly.
>   

LVM copies the buffer!?
I don't think so...
LVM is near-zero overhead, so I would be surprised if it copied the buffer.
Also I don't think it was needed in their case, except maybe if there is 
an I/O at the boundary of a logical volume or LVM stripe, which would 
certainly be a mistake at requestor side.
LVM also does not merge requests AFAIR. (visible with mdstat -x 1)

> Or maybe, it is just one system that behaves
> properly with LVM over MD.
>   

hmm maybe...

But me also I have never seen mismatches and the only raid-1's I have 
are above LVM. (except /boot but that's almost never modified)

