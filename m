From: "Dan Williams" <dan.j.williams@gmail.com>
Subject: Re: In Trouble--Please Help! (was Re: Can't add disk to failed raid array)
Date: Mon, 24 Jul 2006 11:26:51 -0700
Message-ID: <e9c3a7c20607241126n614b7941i4319a7889ac12c5e@mail.gmail.com>
References: <200607152056.55090.pwaldo@waldoware.com>
	 <200607230753.47853.pwaldo@waldoware.com>
	 <17603.25777.274507.385333@cse.unsw.edu.au>
	 <200607230832.48807.pwaldo@waldoware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200607230832.48807.pwaldo@waldoware.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Paul Waldo <pwaldo@waldoware.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 7/23/06, Paul Waldo <pwaldo@waldoware.com> wrote:
> Here is the dmesg output.  No log files are created with the FC5 rescue disk.
> Thanks!
I ran into this as well, I believe at this point you want to set:

md-mod.start_dirty_degraded=1

as part of your boot options.  Understand you may see some filesystem
corruption as noted in the documentation.

See:
http://www.linux-m32r.org/lxr/http/source/Documentation/md.txt?v=2.6.17#L54

Regards,

Dan
