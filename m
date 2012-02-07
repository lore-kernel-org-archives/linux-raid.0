From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: imsm raid is always readonly on boot
Date: Tue, 07 Feb 2012 21:47:13 +0000
Message-ID: <4F319BE1.2010306@anonymous.org.uk>
References: <4F3111D9.2060303@profihost.ag> <4F314CBC.8010102@redhat.com> <4F316273.7030109@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F316273.7030109@profihost.ag>
Sender: linux-raid-owner@vger.kernel.org
To: Stefan Priebe <s.priebe@profihost.ag>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/02/2012 17:42, Stefan Priebe wrote:
[...]
> md127 : inactive sdb[1](S) sda[0](S)
> 5544 blocks super external:imsm

I don't know what the answer is, but I suspect that the members of the 
container both being marked as spares may be (part of) the problem.

Cheers,

John.

