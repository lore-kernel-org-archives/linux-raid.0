From: Felix Koop <fdp@fkoop.de>
Subject: Re: mdadm will only start root device degraded
Date: Mon, 14 Aug 2017 07:18:10 +0200
Message-ID: <1502687890.24364.1.camel@fkoop.de>
References: <1502092265.23002.9.camel@fkoop.de>
         <598DF0A1.5030902@youngman.org.uk> <1502529627.31985.2.camel@fkoop.de>
         <8a5a5958-b2d6-ee8e-1d06-b61466951bcf@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8a5a5958-b2d6-ee8e-1d06-b61466951bcf@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Anthony Youngman <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> The thing is, which happens first in the boot sequence? Unlocking
> the 
> crypto, or assembling the mirror? Because if the boot attempts to 
> assemble the mirror before it unlocks the crypto, this is going to
> cause 
> exactly the scenario you describe.
> 

OK, I understand. But then: Where is the order of the boot sequence
defined? How do I change the order of the boot sequence? How do I make
sure that assembling the mirror is done after unlocking the crypto?

-- 
Mit freundlichen Grüßen

Felix Koop
fkoop@fkoop.de

