From: Daniel Reurich <daniel@centurion.net.nz>
Subject: Re: RAID 5 with bad blocks
Date: Tue, 28 Sep 2010 09:26:18 +1300
Message-ID: <1285619178.22938.8.camel@localhost.localdomain>
References: <20100925000351.M29572@agusta.se>
	 <20100926232102.M67000@agusta.se>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100926232102.M67000@agusta.se>
Sender: linux-raid-owner@vger.kernel.org
To: Carl-Johan =?ISO-8859-1?Q?W=E4gner?= <carl-johan.wagner@agusta.se>
Cc: linux-raid@vger.kernel.org, fafler@gmail.com
List-Id: linux-raid.ids


> 'dd' is NOT the program one would want to use for this task.
> "ddrescue" is the one!
> NB: dd_rescue is not the same program, and may or may not work. Just note that
> "apt-get install ddrescue" installs dd_rescue, not ddrescue...
> ddrescue is downloaded (with e g curl) from:
> # curl ftp.gnu.org/gnu/ddrescue/ddrescue-1.13.tar.gz >ddrescue-1.13.tar.gz
> 
or apt-get install gddrescue 


