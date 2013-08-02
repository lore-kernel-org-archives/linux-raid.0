From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: RFC swap over raid1
Date: Fri, 2 Aug 2013 23:31:54 +0200
Message-ID: <20130802213154.GA6902@www5.open-std.org>
References: <51FB63C8.2090300@hardwarefreak.com> <CAH3kUhE2ys1nGetLy0p=9rj2BxajAvBdWACFXHMe4TP81zNh=w@mail.gmail.com> <51FBD2DC.3010900@redhat.com> <CAH3kUhELqOF3kruP1j94g3Yd4PwKL91rgUjoLDS=CTK5ieBuhg@mail.gmail.com> <51FBDFDF.70008@redhat.com> <CAH3kUhGepSynVH_bbSGfvtfVL5-84=jXhCZu7m90F7uP7GU=aw@mail.gmail.com> <51FBE34B.3000504@redhat.com> <CAH3kUhH840NmKbzOitQCZoPTfO3Oo+RqeCVvb3T_m3uRhKM1aA@mail.gmail.com> <20130802182640.GA31414@www5.open-std.org> <CAH3kUhGmPe2oHNOgTsqCt_0EVMKLnB1afnX8tZ0tt5wSm2aZ3A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAH3kUhGmPe2oHNOgTsqCt_0EVMKLnB1afnX8tZ0tt5wSm2aZ3A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Doug Ledford <dledford@redhat.com>, Stan Hoeppner <stan@hardwarefreak.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Aug 02, 2013 at 03:39:22PM -0300, Roberto Spadim wrote:
> hum, swap "use" more sequencial writes or random writes?
> i tested raid1 vs raid10,far for random writes/read and i'm using
> raid1 for this kind of workload, for sequencial reads/writes the
> raid10,far is faster (at least in my tests)

swap use sequential writes, I think, when a process is swapped out.
There is not much difference between the different mirrorred 
raid layouts when it comes to random or sequential writes.
anyway the elevator for the whole  disk orders writes.


It is more when you need to swap in a process, that you need the 
read speed of raid10,far. Especially for big processes like firefox
or libreoffice.

Best regards
Keld
