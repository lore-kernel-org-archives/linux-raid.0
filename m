From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Ok to go ahead with this setup?
Date: Thu, 22 Jun 2006 11:38:27 -0700
Message-ID: <449AE3A3.6080208@zytor.com>
References: <bb145bd20606221008p131d4daem289a6b9300757c66@mail.gmail.com> <62b0912f0606221104q2f47f574i86441efed5831957@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <62b0912f0606221104q2f47f574i86441efed5831957@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Molle Bestefich <molle.bestefich@gmail.com>
Cc: Christian Pernegger <pernegger@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Molle Bestefich wrote:
> Christian Pernegger wrote:
>> Intel SE7230NH1-E mainboard
>> Pentium D 930
> 
> HPA recently said that x86_64 CPUs have better RAID5 performance.

Actually, anything with SSE2 should be OK.

	-hpa
