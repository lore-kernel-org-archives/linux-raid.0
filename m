From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Simple question, maybe
Date: Thu, 27 Jun 2002 04:17:01 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15642.1309.651737.496391@notabene.cse.unsw.edu.au>
References: <1025113529.1793.8.camel@jason.storix.com>
	<15642.421.825234.16918@notabene.cse.unsw.edu.au>
	<1025114738.1794.19.camel@jason.storix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jason Shelton on  June 26
To: Jason Shelton <jason@storix.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On  June 26, jason@storix.com wrote:
> 
> That was exactly what I needed, thank you very much. Now, if I may,
> where did you find that? I've been looking all over the place and kept
> hitting dead ends.

Use the source, luke:
linux/drivers/md/md.c:

__setup("raid=", raid_setup);

and

static int __init raid_setup(char *str)
{
	int len, pos;

	len = strlen(str) + 1;
	pos = 0;

	while (pos < len) {
		char *comma = strchr(str+pos, ',');
		int wlen;
		if (comma)
			wlen = (comma-str)-pos;
		else	wlen = (len-1)-pos;

		if (!strncmp(str, "noautodetect", wlen))
			raid_setup_args.noautodetect = 1;
		pos += wlen+1;
	}
	raid_setup_args.set = 1;
	return 1;
}

NeilBrown
