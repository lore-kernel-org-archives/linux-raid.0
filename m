From: Beolach <beolach@gmail.com>
Subject: Re: RAID5 to RAID6 reshape?
Date: Mon, 18 Feb 2008 05:38:15 -0700
Message-ID: <aebf5d970802180438w7a4d40ban3f66ee1dbc38d259@mail.gmail.com>
References: <aebf5d970802161958x17a9da92r25663703dc0df05f@mail.gmail.com>
	 <18360.8065.335494.142060@tree.ty.sabi.co.UK>
	 <20080217074526.29d3c5c5@hardcode42.net>
	 <20080218062604.05ae4821@szpak>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080218062604.05ae4821@szpak>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Feb 17, 2008 10:26 PM, Janek Kozicki <janek_listy@wp.pl> wrote:
> Conway S. Smith said:     (by the date of Sun, 17 Feb 2008 07:45:26 -0700)
>
> > Well, I was reading that LVM2 had a 20%-50% performance penalty,
>
> huh? Make a benchmark. Do you really think that anyone would be using
> it if there was any penalty bigger than 1-2% ? (random access, r/w).
>
> I have no idea what is the penalty, but I'm totally sure I didn't
> notice it.
>

(Oops, replied straight to Janek, rather than the list.  Sorry.)

I saw those numbers in a few places, the only one I can remember off
the top of my head was the Gentoo-Wiki:
<http://gentoo-wiki.com/HOWTO_Gentoo_Install_on_Software_RAID_mirror_and_LVM2_on_top_of_RAID>.
Looking at its history, that warning was added back on 23 Dec. 2006,
so it could very well be out-of-date.  Good to hear you don't notice
any performance drop.  I think I will try to run some benchmarks.
What do you guys recommend using for benchmarking?  Plain dd,
bonnie++?


Conway S. Smith
