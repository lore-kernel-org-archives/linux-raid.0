From: "John Stoffel" <john@stoffel.org>
Subject: Re: Recovery Raid6 Degraded
Date: Tue, 14 Apr 2015 16:27:16 -0400
Message-ID: <21805.30756.320605.160993@quad.stoffel.home>
References: <CACsoFmjWW7mqSA8OKZZEPhpFidf-exSMm771ZOp0TssSYydcrw@mail.gmail.com>
	<alpine.DEB.2.02.1504132234220.16871@uplift.swm.pp.se>
	<CACsoFmiCXw1dgpqtz33rA5ejMhYsndi68L63OdpRoU_XyCfFFg@mail.gmail.com>
	<alpine.DEB.2.02.1504141617220.16871@uplift.swm.pp.se>
	<CACsoFmiCoZGRoUWpxg_PLw6hyhW1mAB0TZFO94MZ6Kix-DxMOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACsoFmiCoZGRoUWpxg_PLw6hyhW1mAB0TZFO94MZ6Kix-DxMOA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Emanuel Domingos <emanuelsdrock@gmail.com>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Make sure you add in a bitmap to your array, to make rebuilds quicker
after a system crash.

mdadm --grow /dev/md126 --bitmap internal



