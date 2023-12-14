Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98ED22112
	for <linux-raid@vger.kernel.org>; Thu, 14 Dec 2023 20:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VukSASCK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702586618;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YoSbF7CE1jkSYCWO+ZcHd096bnMLzGvxVdv7jfIWj+4=;
	b=VukSASCKs1sPHTvE7l99X8mh/9myyOCqLcTjwP81474lxIaQyICADGXrKZy+wHa7dSmfJQ
	WP2tH8b5PjXK/rEpS1KBoJSNAmAk4jH5J/Z5KUtNEXGtbhwYSNEufNAH3dUUBlZtSyrNGS
	LYZesYQlzaF4DiGAsxMajwmA2OoNOfI=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-561-TNVsFVSeMdeRGbonf2WgyA-1; Thu, 14 Dec 2023 15:43:36 -0500
X-MC-Unique: TNVsFVSeMdeRGbonf2WgyA-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-67f11c0a042so6747176d6.2
        for <linux-raid@vger.kernel.org>; Thu, 14 Dec 2023 12:43:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702586614; x=1703191414;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YoSbF7CE1jkSYCWO+ZcHd096bnMLzGvxVdv7jfIWj+4=;
        b=UhoTlM+Xrj50DQ7LYShdgdpJFSLTi0pXPL/4YoNOxatnloXBdLRp39rujys5EOJKGi
         YlFcZdBTbJ2TAyu2gg5N1i9j2pj+2pX9QTbNZYhQAmfWW4baTm3ZsyIr8bhtfH2dYOWp
         x3lxb0Z4GyGmRJ3PJiQwCkwsRBhql6ll2O28D9FxTa/PkbHEYY+I1oHN1oyu2JUIcU9o
         D5+uxrpAsgxRoQnwCtkbPLoynq6NcNT4AL6Th4DMPqIW9p39oHeO7xz2KAkefANDeTqt
         eOEQNf++8Xym6KsMv01AtZiU2rz01wJuteS7nehUIhrChLNov4b7ndUpmWDYOduVecgx
         Ti/g==
X-Gm-Message-State: AOJu0Yzimf6i47UgNann0rbY+BKt1HCkEXCPCRB1hIzq8lzV99ka1lb9
	SJh/5nKUOXbJnPyscndVTOk81otrGFcYO3WEiwMh/cv02AZeFABblQe4vrN4ymQzOBJlvWwfNTz
	JYfOti4T5pmo/pPScTjVo8yullPki2yDb
X-Received: by 2002:a05:6214:9d3:b0:67e:f7f2:2ba5 with SMTP id dp19-20020a05621409d300b0067ef7f22ba5mr3508878qvb.85.1702586614813;
        Thu, 14 Dec 2023 12:43:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFFfhR/HdLh95DVAK4DC4/K9YW0YtDCxuI7/SKInhAlWtZEnTWc7zaI8xH4KQPRTNbzqb652A==
X-Received: by 2002:a05:6214:9d3:b0:67e:f7f2:2ba5 with SMTP id dp19-20020a05621409d300b0067ef7f22ba5mr3508874qvb.85.1702586614610;
        Thu, 14 Dec 2023 12:43:34 -0800 (PST)
Received: from [192.168.50.193] ([134.195.185.129])
        by smtp.gmail.com with ESMTPSA id z18-20020ad44152000000b0067f12e3772csm319485qvp.122.2023.12.14.12.43.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Dec 2023 12:43:34 -0800 (PST)
Message-ID: <67ca09b8-2405-4b4f-abce-83bf0c988349@redhat.com>
Date: Thu, 14 Dec 2023 15:43:33 -0500
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Announcement: mdadm maintainer update
Content-Language: en-US
To: Jes Sorensen <jes@trained-monkey.org>,
 "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>
Cc: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
 Song Liu <songliubraving@fb.com>, Coly Li <colyli@suse.de>,
 "Luse, Paul E" <paul.e.luse@intel.com>
References: <e5c7971f-a600-08ec-0f31-8f255bd99979@trained-monkey.org>
From: Nigel Croxon <ncroxon@redhat.com>
In-Reply-To: <e5c7971f-a600-08ec-0f31-8f255bd99979@trained-monkey.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Congratulations Mariusz !


On 12/14/23 9:18 AM, Jes Sorensen wrote:
> Hi
>
> I wanted to let everyone know that Mariusz Tkaczyk is joining as mdadm
> co-maintainer.
>
> Anyone who has spent time on this list over the last couple of years
> knows Mariusz as a serious and thorough patch reviewer and I believe he
> will do a great job as co-maintainer. Most people will also have noticed
> I have been struggling keeping up due to lack of time, especially since
> mdadm is no longer directly linked to my daytime job. Having Mariusz
> onboard should help us progress faster.
>
> Thanks for stepping up Mariusz!
>
> Jes
>

