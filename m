From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: Raid 1, new disk can't be added after replacing faulty disk
Date: Mon, 7 Jan 2008 12:11:58 -0700
Message-ID: <e9c3a7c20801071111t11bdd5fx1b8d59bd0a763c4c@mail.gmail.com>
References: <1199713488.3202.19.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1199713488.3202.19.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Radu Rendec <radu.rendec@ines.ro>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Jan 7, 2008 6:44 AM, Radu Rendec <radu.rendec@ines.ro> wrote:
> I'm experiencing trouble when trying to add a new disk to a raid 1 array
> after having replaced a faulty disk.
>
[..]
> # mdadm --version
> mdadm - v2.6.2 - 21st May 2007
>
[..]
> However, this happens with both mdadm 2.6.2 and 2.6.4. I downgraded to
> 2.5.4 and it works like a charm.

Looks like you are running into the issue described here:
http://marc.info/?l=linux-raid&m=119892098129022&w=2
