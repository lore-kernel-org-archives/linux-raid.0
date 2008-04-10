From: john <john4lists@gmail.com>
Subject: Re: emergency recovery
Date: Thu, 10 Apr 2008 12:09:28 -0400
Message-ID: <47FE3BB8.5010300@gmail.com>
References: <51c8a7be0804092329i3353055ai6216dc0e6b4066ea@mail.gmail.com> <ftkclu$t6f$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ftkclu$t6f$1@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mario 'BitKoenig' Holbe wrote:
> jeff sacksteder <jsacksteder@gmail.com> wrote:
>   
>> It is essential that I not make this worse than it is. Is the
>>     
>
> Well, this in mind the first thing you should do is taking raw images
> from all the component drives before even thinking about any kind of
> recovery.

Thanks.  I'll try to use a fresh drive with a ddrescue(ed) image on it 
with the corrupt drive. I may do the same with the stale(evms 
terminology?) drive.

Do I need to dd image all 6 dives somewhere to be safe?

 I want to force assemble 4 good +1stale +1 corrupt to a degraded raid5 
array with 5 good +1 corrupt.  I could avoid dd imaging the 4 good 
drives if I could mark these 4 drives read-only.  Is that possible or 
with the forced assembly does it need to write new md meta data to all 
the drives and therefore need to modify these drives?

  Tell me to start a new thread if this doesn't pertain to the OP's 
question.

