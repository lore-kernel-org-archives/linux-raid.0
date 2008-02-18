From: Janek Kozicki <janek_listy@wp.pl>
Subject: Re: RAID5 to RAID6 reshape?
Date: Mon, 18 Feb 2008 15:42:03 +0100
Message-ID: <20080218154203.6e2d1483@szpak>
References: <aebf5d970802161958x17a9da92r25663703dc0df05f@mail.gmail.com>
	<18360.8065.335494.142060@tree.ty.sabi.co.UK>
	<20080217074526.29d3c5c5@hardcode42.net>
	<20080218062604.05ae4821@szpak>
	<aebf5d970802180438w7a4d40ban3f66ee1dbc38d259@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <aebf5d970802180438w7a4d40ban3f66ee1dbc38d259@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Beolach said:     (by the date of Mon, 18 Feb 2008 05:38:15 -0700)

> On Feb 17, 2008 10:26 PM, Janek Kozicki <janek_listy@wp.pl> wrote:
> > Conway S. Smith said:     (by the date of Sun, 17 Feb 2008 07:45:26 -0700)
> >
> > > Well, I was reading that LVM2 had a 20%-50% performance penalty,
> <http://gentoo-wiki.com/HOWTO_Gentoo_Install_on_Software_RAID_mirror_and_LVM2_on_top_of_RAID>.

hold on. This might be related to raid chunk positioning with respect
to LVM chunk positioning. If they interfere there indeed may be some
performance drop. Best to make sure that those chunks are aligned together.

-- 
Janek Kozicki                                                         |
