From: pg@raid2.to.sabi.co.UK (Peter Grandi)
Subject: Re: super slow reshape speed after power failure
Date: Wed, 19 Dec 2012 18:13:45 +0000
Message-ID: <20690.985.485075.572934@tree.ty.sabi.co.UK>
References: <CA+Z7oPhgrmC+nNxdRXjNPdOTSRbmy_aEYm=m_sO=7H6fBjh3yw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+Z7oPhgrmC+nNxdRXjNPdOTSRbmy_aEYm=m_sO=7H6fBjh3yw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> [ ... ]  reshape was running it was running around 4mb/s,
> which is slow to begin with. [ ... resync too ... ]

A bigger value for 'md/stripe-cache' might help, alleviating
some alignment issues, but usually it is not like 10 times
better, but might be still worthwhile even if it will be still
slow.

