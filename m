From: "J. Ryan Earl" <ryan@dynaconnections.com>
Subject: Re: RAID 16?
Date: Thu, 02 Feb 2006 15:18:14 -0600
Message-ID: <43E27716.10506@dynaconnections.com>
References: <43E19FAB.4000603@cogweb.net> <pan.2006.02.02.16.17.03.859560@smurf.noris.de> <Pine.GSO.4.62.0602021726010.14030@shaka.acc.umu.se> <Pine.LNX.4.56.0602021651370.19057@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0602021651370.19057@lion.drogon.net>
Sender: linux-raid-owner@vger.kernel.org
To: Gordon Henderson <gordon@drogon.net>
Cc: Mattias Wadenstein <maswan@acc.umu.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Gordon Henderson wrote:

>I've actually had very good results hot swapping  SCSI drives on a live
>linux system though.
>
>Anyone tried SATA drives yet?
>
Yes, and it does NOT work yet.  libata does not support hotplugging of 
harddrives yet: http://linux.yyz.us/sata/features.html 

It supports hotplugging of the PCI controller itself, but not harddrives.

-ryan
