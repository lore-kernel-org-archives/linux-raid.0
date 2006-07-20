From: "Pieter Steyn" <pieterste@gmail.com>
Subject: Re: Megaraid, howto?
Date: Thu, 20 Jul 2006 16:33:49 +0200
Message-ID: <c49e66200607200733u6ad8d669i6ab2ca598495cd75@mail.gmail.com>
References: <c49e66200607200014wbefb21ay4d9a24ccd43356b0@mail.gmail.com>
	 <Pine.LNX.4.62.0607200856450.24627@chaos.egr.duke.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.62.0607200856450.24627@chaos.egr.duke.edu>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Joshua Baker-LePain <jlb17@duke.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks alot Joshua!

This is _exactly_ what I was looking for.

Cheers!

On 7/20/06, Joshua Baker-LePain <jlb17@duke.edu> wrote:
> On Thu, 20 Jul 2006 at 9:14am, Pieter Steyn wrote
>
> > I have a few hosts that use Megaraid controllers.
> >
> > Could someone please show me an effective way to monitor the status?
> >
> > I've used the software on dells website, and the only program partly
> > useful was Megamon, which is a gui menu based program that runs on the
> > shell, I've written an expect script that gives me the proper output
> > when I run the program on that shell, but it does not work from within
> > crontab / ssh hostname "command".
>
> Problems like that are almost always due to a difference in the shell
> environments of your login shell and crontab.  Make sure all your paths
> are explicit and stuff (that's a technical term, son) like that.
>
> > If anyone could please tell me of either an alternative way / or how I
> > can get my expect script to work through crontab, I'd greatly
> > apreciate it!
>
> I have a (very/embarrassingly) crude script which uses megarc (downloaded
> directly from LSI).  It greps the output of "megarc -dispCfg -a0" for
> DEGRADED.  If it finds that then it emails me and also touches a state
> file so it doesn't continue mailing me every 15 minutes (which is how
> often I run it).
>
> --
> Joshua Baker-LePain
> Department of Biomedical Engineering
> Duke University
>
