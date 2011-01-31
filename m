From: NeilBrown <neilb@suse.de>
Subject: Re: documentation
Date: Tue, 1 Feb 2011 08:58:51 +1100
Message-ID: <20110201085851.2b665f1a@notabene.brown>
References: <AANLkTindmhPU3Lazk33XPaS_Pw7AL52LXKeXAML6F3Y=@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTindmhPU3Lazk33XPaS_Pw7AL52LXKeXAML6F3Y=@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 31 Jan 2011 19:39:03 -0200 Roberto Spadim <roberto@spadim.com.b=
r>
wrote:

> hi guys, where=B4s the official documentation page (wiki)? is it at
> linux kernel source code? or at a wikipedia or another wiki page?
> i found this:
> http://www.linuxfoundation.org/collaborate/workgroups/linux-raid
> at wikipedia
> and some documentation inside kernel source code
> what=B4s the most updated (official)?
>=20

"official" has always struck me as a rather strange term in this sort o=
f
context.  It implies that there is an 'office' which the 'official' hol=
ds.
I wonder what this 'office' is....

However to be useful instead of philosophical:

 - the source code is the definitive documentation.  However few people=
 can
   read it very well.
 - the man pages in the mdadm package are the formal documentation that=
 I am
   most likely to update in anything close to a timely manner.  In part=
icular
     man 4 md
   is worth a read.
 - An archive of this mailing line (linux-raid) is likely to be the bes=
t
   informal source of documentation.  It contains lots of valuable
   information, but of course is not structured very well.
 - https://linux-raid.wiki.kernel.org/ is a community-maintained wiki w=
hich
   should be reasonably reliable. (that is the same location as the lin=
k that
   you found above).
 - the doco in the kernel (Documentation/md.txt) is hardly ever updated=
 and so
   is probably badly out of date.  Sorry.
 - As has been mentioned, http://neil.brown.name/blog/mdadm and=20
   http://neil.brown.name/blog/SoftRaid sometimes contain useful inform=
ation
   but I don't write as often as I would like to.
 - This is a Book: Managing RAID on Linux
     http://oreilly.com/catalog/9781565927308/index.html?CMP=3DIL7015
   however it is now about 8 years old, so it will be missing a lot of =
new
   stuff.

Hope that helps,
NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
