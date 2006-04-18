From: Jeff Garzik <jeff@garzik.org>
Subject: Re: libata retry - disable?
Date: Tue, 18 Apr 2006 02:50:28 -0400
Message-ID: <44448C34.6060605@garzik.org>
References: <62b0912f0604172330g274c286fje159f9d920d5ec61@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <62b0912f0604172330g274c286fje159f9d920d5ec61@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Molle Bestefich <molle.bestefich@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Molle Bestefich wrote:
> Does anyone know of a way to disable libata's 5-time retry when a read fails?
> 
> It has the effect of causing every failed sector read to take 6
> seconds before it fails, causing raid5 rebuilds to go awfully slow. 
> It's generally undesirable too, when you've got RAID on top that can
> write replacement data onto the failed sectors..

libata does not retry at all.

	Jeff



