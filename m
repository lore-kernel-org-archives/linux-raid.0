From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Subject: Re: Why move all map_sg/unmap_sg for slave channel to its client?
Date: Fri, 10 Jun 2011 22:19:01 +0900 (JST)
Message-ID: <20110610.221901.193681450.anemo@mba.ocn.ne.jp>
References: <BANLkTik9kZjJs5H2kvM+xAtd_CR5NA0dDw@mail.gmail.com>
	<BANLkTikzDEx2netonGyhskYFtiAEAxq5XQ@mail.gmail.com>
	<4DF19251.1090100@st.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4DF19251.1090100@st.com>
Sender: linux-kernel-owner@vger.kernel.org
To: viresh.kumar@st.com
Cc: dan.j.williams@intel.com, linus.walleij@linaro.org, vinod.koul@intel.com, linux-kernel@vger.kernel.org, shiraz.hashim@st.com, armando.visconti@st.com, bhupesh.sharma@st.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 10 Jun 2011 09:11:05 +0530, viresh kumar <viresh.kumar@st.com> wrote:
> >>> I thought map_sg/unmap_sg for slave channels will be handled according
> >>> to the flags passed in prep_slave_sg(). But then i found following patch:
...
> Linus, Dan,
> 
> Got it. Thanks for your replies.

JFYI, the old discussion was here:

https://lkml.org/lkml/2009/7/24/114

---
Atsushi Nemoto
