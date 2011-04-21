From: Luca Berra <bluca@comedia.it>
Subject: Re: debian software raid1
Date: Thu, 21 Apr 2011 08:15:45 +0200
Message-ID: <20110421061545.GA15220@maude.comedia.it>
References: <1303215166.2809.8.camel@valio> <BANLkTik7iVaUH2bn9spW2gtV-TkjLH2Qag@mail.gmail.com> <4DADB24F.2030300@cdf.toronto.edu> <20110420085148.12ac0002@notabene.brown> <4DAE29EA.4040306@gmail.com> <4DAEF2F1.8080204@cdf.toronto.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4DAEF2F1.8080204@cdf.toronto.edu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Apr 20, 2011 at 10:51:29AM -0400, Iordan Iordanov wrote:
> raiding the whole drive. This does have the drawback that any replacement 
> drives have to be the same size or bigger than what you had to begin with. 

I am missing your point here.
The requirement of having a replacement drive at least as big as the
original one, usually comes from the fact that a smaller drive won't be
able to contain your data, not from some md voodoo.

If someone here still believes that drives from different vendors with
the same nominal size have different real size please read:
http://www.idema.org/wp-content/plugins/download-monitor/download.php?id=1192


-- 
Luca Berra -- bluca@comedia.it
