import React from 'react';

import LaunchpadWindow from 'src/shared-components/launchpadWindow';

import { GridHelper, NewsVideoContainer } from './style';

import video from './bbc.mp4';

const NewsVideo = () => {
	return (
		<GridHelper>
			<LaunchpadWindow title="News Video">
				<NewsVideoContainer>
					<video src={video} autoplay="true" loop="true" playsinline="true" />
				</NewsVideoContainer>
			</LaunchpadWindow>
		</GridHelper>
	);
};

export default NewsVideo;
