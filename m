Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC22360AE
	for <linux-raid@vger.kernel.org>; Fri,  5 Jan 2024 23:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gb0t3p0y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C24FC433CA
	for <linux-raid@vger.kernel.org>; Fri,  5 Jan 2024 23:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704496701;
	bh=c1GFZU6SU+5rarKnAgV9i4NB4cyQ0+qghJTBtkgeYR8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=gb0t3p0ySEQb/xm+za5ifdgCuW126nITtRfOmnMXfFuEuiXXFSRDG6SWqVJ70/Piw
	 lRSqFsJDN8QK0BiAoDolm6o4uJRKZEWRZUy8193xkrV7EG2Hy9D0baPt6o0gidqBWb
	 6YDuz8DKE7QBZzy8rdsX2KMr2PPQictDhRYMonw8+AwcX09wWXR7AgPZcHjlQ1WhSw
	 cqVsGD3WnOzHV66GavPFEZvT/A1kLt9Yqk3n/bqvocaIZesLZA3zTPf9SMptEKHToX
	 pl0VVwAdz/b9a5W1blbhNa3R7Xxegcb6JnROGvvJaKlzv79D4c9/w+MKcXPmRQYjEQ
	 vZUkd2mpqRMDw==
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-50e7abe4be4so68136e87.2
        for <linux-raid@vger.kernel.org>; Fri, 05 Jan 2024 15:18:21 -0800 (PST)
X-Gm-Message-State: AOJu0YzZlgDeWm5HuXw7PDNAPvzLxdk7FlbBoubevSEk4kdKUj3EtY+s
	RMTg8ccCmokrMXe7xmGGDqzTARaezFJ5+90tZNk=
X-Google-Smtp-Source: AGHT+IGtAaWIUgccEkICNQZx6tl2n4MLeBT0kZRv3/Yx8LQdz8xrnd5gL+nvW1lxHtYXy5QtC2y30fYPQ0aWukuVXFM=
X-Received: by 2002:a05:6512:239d:b0:50b:f03c:1ea2 with SMTP id
 c29-20020a056512239d00b0050bf03c1ea2mr90311lfv.84.1704496699189; Fri, 05 Jan
 2024 15:18:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231221013914.3108026-1-song@kernel.org> <1faa5e2e-e4c6-4f82-9ceb-7440939bc167@linux.intel.com>
 <CAPhsuW4L_nZwMfUYMzNg9_p5OyePpy2H2sFqC5-cVcHgFh48Sw@mail.gmail.com> <20240105105827.00007e96@linux.intel.com>
In-Reply-To: <20240105105827.00007e96@linux.intel.com>
From: Song Liu <song@kernel.org>
Date: Fri, 5 Jan 2024 15:18:07 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5_tidq_kh7NEzBvvyLQZX4cRj3vE8L=g7y1-HxM8DUzA@mail.gmail.com>
Message-ID: <CAPhsuW5_tidq_kh7NEzBvvyLQZX4cRj3vE8L=g7y1-HxM8DUzA@mail.gmail.com>
Subject: Re: [PATCH mdadm] tests: Gate tests for linear flavor with variable LINEAR
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc: Mateusz Kusiak <mateusz.kusiak@linux.intel.com>, linux-raid@vger.kernel.org, 
	jes@trained-monkey.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Mariusz,

Thanks for these explanations.

On Fri, Jan 5, 2024 at 1:58=E2=80=AFAM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
[...]
>
> It i just an example, I didn't test it. The final message depends on
> option you will choose.
>
> Mdadm is a kind of user interface for MD driver. I expect that not only
> developers are using this test suite. We need to keep it easy to use, mes=
sages
> should be meaningful and helpful.
>
> > >
> > > Another thing is "--raidtype=3Dlinear" option, is probably redundant =
now.
> > >
>
> Env variable are better implemented now than this --raidtype option. Ther=
e is
> more work to do to make --raidtype fully valid because --raidtype uses
> filtering by test name. Test may define set of levels used, even if the n=
ame
> doesn't point to any level. So yes, I think that we can eventually remove
> --raidtype=3Dlinear as it is not really useful but I give it up to Song.

How about we add something like the following on top of this patch?

Thanks,
Song

diff --git i/test w/test
index b244453b1cec..49a36c3b8ef2 100755
--- i/test
+++ w/test
@@ -140,6 +140,7 @@ do_help() {
                --raidtype=3D
raid0|linear|raid1|raid456|raid10|ddf|imsm
                --disable-multipath         Disable any tests
involving multipath
                --disable-integrity         Disable slow tests of
RAID[56] consistency
+               --disable-linear            Disable any tests involving lin=
ear
                --logdir=3Ddirectory          Directory to save all logfile=
s in
                --save-logs                 Usually use with --logdir toget=
her
                --keep-going | --no-error   Don't stop on error, ie.
run all tests
@@ -255,6 +256,9 @@ parse_args() {
                --disable-integrity )
                        unset INTEGRITY
                        ;;
+               --disable-linear )
+                       unset LINEAR
+                       ;;
                --dev=3D* )
                        case ${i##*=3D} in
                        loop )
diff --git i/tests/func.sh w/tests/func.sh
index 5053b0121f1d..d7561f3c20cf 100644
--- i/tests/func.sh
+++ w/tests/func.sh
@@ -123,6 +123,14 @@ check_env() {
        modprobe multipath 2> /dev/null
        grep -sq 'Personalities : .*multipath' /proc/mdstat &&
                MULTIPATH=3D"yes"
+
+       # Check whether to run linear tests
+       modprobe linear 2> /dev/null
+       grep -sq 'Personalities : .*linear' /proc/mdstat &&
+               LINEAR=3D"yes"
+       if [ "$LINEAR" !=3D "yes" ]; then
+               echo "test: skipping tests for linear, which is
removed in upstream 6.8+ kernels"
+       fi
 }

 do_setup() {
