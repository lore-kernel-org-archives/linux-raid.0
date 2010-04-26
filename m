From: MRK <mrk@shiftmail.org>
Subject: Re: Suggestion needed for fixing RAID6
Date: Mon, 26 Apr 2010 18:53:50 +0200
Message-ID: <4BD5C51E.9040207@shiftmail.org>
References: <626601cae203$dae35030$0400a8c0@dcccs>
 <20100423065143.GA17743@maude.comedia.it>
 <695a01cae2c1$a72907d0$0400a8c0@dcccs> <4BD193D0.5080003@shiftmail.org>
 <717901cae3e5$6a5fa730$0400a8c0@dcccs> <4BD3751A.5000403@shiftmail.org>
 <756601cae45e$213d6190$0400a8c0@dcccs> <4BD569E2.7010409@shiftmail.org>
 <7a3e01cae53f$684122c0$0400a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <7a3e01cae53f$684122c0$0400a8c0@dcccs>
Sender: linux-raid-owner@vger.kernel.org
To: Janos Haar <janos.haar@netcenter.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/26/2010 02:52 PM, Janos Haar wrote:
>
> Oops, you are right!
> It was my mistake.
> Sorry, i will try it again, to support 2 drives with dm-cow.
> I will try it.

Great! post here the results... the dmesg in particular.
The dmesg should contain multiple lines like this "raid5:md3: read error 
corrected ....."
then you know it worked.
