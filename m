From: Wolfgang Denk <wd@denx.de>
Subject: Re: New XFS benchmarks using David Chinner's recommendations for XFS-based optimizations.
Date: Mon, 31 Dec 2007 00:44:15 +0100
Message-ID: <20071230234415.1E11B24755@gemini.denx.de>
References: <5d96567b0712301533v3a7fcfd1pfce02563526a39bf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <xfs-bounce@oss.sgi.com>
In-reply-to: Your message of "Mon, 31 Dec 2007 01:33:14 +0200."
             <5d96567b0712301533v3a7fcfd1pfce02563526a39bf@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
To: Raz <raziebe@gmail.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, xfs@oss.sgi.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

In message <5d96567b0712301533v3a7fcfd1pfce02563526a39bf@mail.gmail.com> you wrote:
> what is nobarrier ?
...
> > > # mount -o logbsize=256k,nobarrier <dev> <mtpt>

See http://oss.sgi.com/projects/xfs/faq.html

Q: How can I address the problem with the write cache?

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
One of the advantages of being a captain is being able to ask for ad-
vice without necessarily having to take it.
	-- Kirk, "Dagger of the Mind", stardate 2715.2
