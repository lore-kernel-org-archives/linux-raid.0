From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: recommended way to add ssd cache to mdraid array
Date: Fri, 11 Jan 2013 19:44:33 -0700
Message-ID: <201301111944.33921.thomas@fjellstrom.ca>
References: <201212212357.19292.thomas@fjellstrom.ca> <201301111151.44384.thomas@fjellstrom.ca> <50F08F96.1050909@hardwarefreak.com>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50F08F96.1050909@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Chris Murphy <lists@colorremedies.com>, linux-raid Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri Jan 11, 2013, Stan Hoeppner wrote:
> On 1/11/2013 12:51 PM, Thomas Fjellstrom wrote:
> >> It's not but as Stan writes it may not be preferred for your
> >> application.
> > 
> > Hm, ok, it is in my mount line, so I'll try it with that off. Though I
> > would be interested in hearing from Stan why it may not be good.
> 
> You should not do this.  This parameter is not a toggle switch intended
> to be flipped on/off at will, but changed only once and left there.

Makes me wonder why they are mount options if they aren't meant to ever be 
changed?

> Never change XFS parameters willy-nilly without knowing the
> consequences.  And currently you certainly do not know them.
> 
> I don't have time for the detailed explanation.  Ask on the XFS list.

Alright, thanks for your help :)

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
