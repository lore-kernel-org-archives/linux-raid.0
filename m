From: "Molle Bestefich" <molle.bestefich@gmail.com>
Subject: Re: Cutting power without breaking RAID
Date: Wed, 5 Jul 2006 23:25:59 +0200
Message-ID: <62b0912f0607051425y3706d786q93d6e590e17b6d0a@mail.gmail.com>
References: <20060628214350.GA23970@rigacci.org> <44A326C5.70205@irule.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44A326C5.70205@irule.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Tim <irule@irule.net>
Cc: Niccolo Rigacci <niccolo@rigacci.org>, linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Tim wrote:
> That would probably be ideal, issue the power off command with
> something like a 30 second timeout, which would give the system time to
> power off cleanly first.

I don't think that's ideal.
Many systems restore power to the last known state, thus powering off
cleanly would result in the machine not coming back up after the power
cycle.

Some machines can be changed to always power on in the BIOS.
If the server administrator remembers to do so, that is.
