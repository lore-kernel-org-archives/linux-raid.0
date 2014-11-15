From: Wolfgang Denk <wd@denx.de>
Subject: Re: failed RAID 5 array
Date: Sat, 15 Nov 2014 07:42:15 +0100
Message-ID: <20141115064215.99B01382C37@gemini.denx.de>
References: <1415807882.4241.36.camel@lappy.neofreak.org> <54653735.90007@turmel.org> <1415971164.4241.38.camel@lappy.neofreak.org> <546606D4.5070406@turmel.org> <1415974131.4241.41.camel@lappy.neofreak.org> <5466173F.2060007@turmel.org> <1415980414.4241.49.camel@lappy.neofreak.org> <54662804.7040005@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <54662804.7040005@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: DeadManMoving <sequel@neofreak.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Phil,

In message <54662804.7040005@turmel.org> you wrote:
>
> Yes.  Braces are expanded as given.  Square brackets are expanded in the
> order found in the filesystem, not the order given.

"in the order found in the filesystem" is not correct.  Pathname
expansion using [ ... ] patterns generates a _sorted_ list. 

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
Quantum particles: The dreams that stuff is made of.
