From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: RFC swap over raid1
Date: Fri, 2 Aug 2013 15:39:22 -0300
Message-ID: <CAH3kUhGmPe2oHNOgTsqCt_0EVMKLnB1afnX8tZ0tt5wSm2aZ3A@mail.gmail.com>
References: <51FAE985.1040809@redhat.com>
	<CAH3kUhH-uc-tXitqZ=xuUYz5A8GY_+dhy+LnvvZTR9gSUJ0Y4A@mail.gmail.com>
	<51FB63C8.2090300@hardwarefreak.com>
	<CAH3kUhE2ys1nGetLy0p=9rj2BxajAvBdWACFXHMe4TP81zNh=w@mail.gmail.com>
	<51FBD2DC.3010900@redhat.com>
	<CAH3kUhELqOF3kruP1j94g3Yd4PwKL91rgUjoLDS=CTK5ieBuhg@mail.gmail.com>
	<51FBDFDF.70008@redhat.com>
	<CAH3kUhGepSynVH_bbSGfvtfVL5-84=jXhCZu7m90F7uP7GU=aw@mail.gmail.com>
	<51FBE34B.3000504@redhat.com>
	<CAH3kUhH840NmKbzOitQCZoPTfO3Oo+RqeCVvb3T_m3uRhKM1aA@mail.gmail.com>
	<20130802182640.GA31414@www5.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130802182640.GA31414@www5.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@keldix.com>
Cc: Doug Ledford <dledford@redhat.com>, Stan Hoeppner <stan@hardwarefreak.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

hum, swap "use" more sequencial writes or random writes?
i tested raid1 vs raid10,far for random writes/read and i'm using
raid1 for this kind of workload, for sequencial reads/writes the
raid10,far is faster (at least in my tests)
